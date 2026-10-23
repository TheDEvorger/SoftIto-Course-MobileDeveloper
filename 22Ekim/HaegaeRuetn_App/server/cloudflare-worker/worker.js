/**
 * HægæRûetn — Cloudflare Worker Free AI Proxy
 *
 * Secure serverless gateway between HægæRûetn Flutter client and GroqCloud Chat Completions API.
 * Keeps GROQ_API_KEY secret and strictly controls free tier quotas.
 */

// In-memory rate limiter per IP for the free tier (Worker instance lifetime)
const ipRequestCounts = new Map();
const RATE_LIMIT_PER_MINUTE = 15;
const RATE_LIMIT_PER_DAY = 120;
const MAX_BODY_BYTES = 32 * 1024; // 32 KB limit

// Allowed models
const PRIMARY_MODEL = 'qwen/qwen3.8-27b';
const FALLBACK_MODEL = 'openai/gpt-oss-20b';

export default {
  async fetch(request, env) {
    // 1. CORS Preflight
    if (request.method === 'OPTIONS') {
      return handleCors(request);
    }

    const url = new URL(request.url);

    // Health check endpoint
    if (request.method === 'GET' && (url.pathname === '/' || url.pathname === '/health')) {
      return jsonResponse({
        status: 'ok',
        service: 'haegaruuetn-ai-proxy',
        primary_model: PRIMARY_MODEL,
        fallback_model: FALLBACK_MODEL,
        timestamp: new Date().toISOString(),
      });
    }

    if (request.method !== 'POST') {
      return jsonResponse({ error: { code: 'method_not_allowed', message: 'Yalnızca POST istekleri kabul edilir.' } }, 405);
    }

    // 2. Client verification
    // Optional app identifier or custom shared token between client and worker
    const appId = request.headers.get('X-App-Id');
    const clientSecret = request.headers.get('X-Hager-Client-Secret');
    if (env.CLIENT_SECRET && clientSecret !== env.CLIENT_SECRET) {
      return jsonResponse({ error: { code: 'unauthorized', message: 'Yetkisiz erişim. İstemci doğrulaması başarısız.' } }, 401);
    }

    // 3. Rate limiting per IP
    const clientIp = request.headers.get('CF-Connecting-IP') || 'anonymous';
    const rateCheck = checkRateLimit(clientIp);
    if (!rateCheck.allowed) {
      return jsonResponse(
        {
          error: {
            code: 'rate_limit_exceeded',
            message: `Kraliyet habercisi meşgul. ${rateCheck.reason}. Lütfen biraz bekleyin.`,
          },
        },
        429
      );
    }

    // 4. Secret validation
    const apiKey = env.GROQ_API_KEY;
    if (!apiKey) {
      return jsonResponse(
        {
          error: {
            code: 'worker_misconfigured',
            message: 'Sunucu tarafında GROQ_API_KEY tanımlanmamış. Lütfen wrangler secret ile ekleyin.',
          },
        },
        500
      );
    }

    // 5. Body validation
    let body;
    try {
      const rawText = await request.text();
      if (rawText.length > MAX_BODY_BYTES) {
        return jsonResponse({ error: { code: 'payload_too_large', message: 'İstek boyutu çok büyük (Maksimum 32KB).' } }, 413);
      }
      body = JSON.parse(rawText);
    } catch {
      return jsonResponse({ error: { code: 'invalid_json', message: 'Geçersiz JSON içeriği.' } }, 400);
    }

    const { messages, model, temperature = 0.7, max_tokens = 600 } = body;
    if (!Array.isArray(messages) || messages.length === 0) {
      return jsonResponse({ error: { code: 'invalid_messages', message: 'En az bir mesaj gereklidir.' } }, 400);
    }

    // Sanitize and limit context length (last 8 messages max)
    const sanitizedMessages = messages.slice(-8).map((m) => ({
      role: m.role === 'assistant' ? 'assistant' : m.role === 'system' ? 'system' : 'user',
      content: String(m.content || '').slice(0, 4000),
    }));

    // Selected model with fallback logic
    const targetModel = model || PRIMARY_MODEL;

    // 6. Forward to GroqCloud Chat Completions
    try {
      const groqResponse = await callGroq(apiKey, targetModel, sanitizedMessages, temperature, max_tokens);

      if (groqResponse.status === 429) {
        return jsonResponse(
          {
            error: {
              code: 'rate_limit_exceeded',
              message: 'GroqCloud ücretsiz kota sınırına ulaşıldı. Lütfen birkaç dakika sonra tekrar deneyin.',
            },
          },
          429
        );
      }

      // If primary model fails with 404/not found, retry once with FALLBACK_MODEL
      if (!groqResponse.ok && targetModel !== FALLBACK_MODEL) {
        const retryResponse = await callGroq(apiKey, FALLBACK_MODEL, sanitizedMessages, temperature, max_tokens);
        if (retryResponse.ok) {
          const data = await retryResponse.json();
          return jsonResponse(data);
        }
      }

      if (!groqResponse.ok) {
        const errorData = await groqResponse.json().catch(() => ({}));
        return jsonResponse(
          {
            error: {
              code: 'groq_error',
              status: groqResponse.status,
              message: errorData?.error?.message || 'Groq yapay zekâ servisinden beklenmeyen bir yanıt alındı.',
            },
          },
          groqResponse.status >= 500 ? 502 : groqResponse.status
        );
      }

      const data = await groqResponse.json();
      return jsonResponse(data);
    } catch (err) {
      return jsonResponse(
        {
          error: {
            code: 'gateway_timeout',
            message: 'Yapay zekâ servisine bağlanırken zaman aşımı veya ağ hatası oluştu.',
          },
        },
        504
      );
    }
  },
};

async function callGroq(apiKey, model, messages, temperature, maxTokens) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 16000); // 16 second timeout

  try {
    const res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model,
        messages,
        temperature: Math.min(Math.max(temperature, 0.1), 1.0),
        max_tokens: Math.min(Math.max(maxTokens, 50), 800),
      }),
      signal: controller.signal,
    });
    return res;
  } finally {
    clearTimeout(timeoutId);
  }
}

function checkRateLimit(ip) {
  const now = Date.now();
  const minuteWindow = 60 * 1000;
  const dayWindow = 24 * 60 * 60 * 1000;

  if (!ipRequestCounts.has(ip)) {
    ipRequestCounts.set(ip, { timestamps: [] });
  }

  const record = ipRequestCounts.get(ip);
  // Remove entries older than 24h
  record.timestamps = record.timestamps.filter((t) => now - t < dayWindow);

  const lastMinute = record.timestamps.filter((t) => now - t < minuteWindow).length;
  if (lastMinute >= RATE_LIMIT_PER_MINUTE) {
    return { allowed: false, reason: 'Dakikalık ücretsiz istek sınırı aşıldı (maks 15 istek/dk)' };
  }

  if (record.timestamps.length >= RATE_LIMIT_PER_DAY) {
    return { allowed: false, reason: 'Günlük ücretsiz kota sınırı aşıldı (maks 120 istek/gün)' };
  }

  record.timestamps.push(now);
  return { allowed: true };
}

function jsonResponse(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-App-Id, X-Hager-Client-Secret',
    },
  });
}

function handleCors(request) {
  return new Response(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-App-Id, X-Hager-Client-Secret',
      'Access-Control-Max-Age': '86400',
    },
  });
}
