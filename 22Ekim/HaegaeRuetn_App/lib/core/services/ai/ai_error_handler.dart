enum AiErrorCode {
  networkError,
  unauthorized,
  rateLimitExceeded,
  serverError,
  timeout,
  invalidResponse,
  workerNotConfigured,
  unknown,
}

/// Structured exception for AI communications.
class AiException implements Exception {
  const AiException({
    required this.code,
    required this.message,
    this.technicalDetails,
    this.httpStatusCode,
  });

  final AiErrorCode code;
  final String message;
  final String? technicalDetails;
  final int? httpStatusCode;

  @override
  String toString() => 'AiException($code): $message';

  factory AiException.fromStatusCode(int status, String? serverMessage) {
    if (status == 401) {
      return AiException(
        code: AiErrorCode.unauthorized,
        message:
            'Yetkilendirme hatası (401). Worker kimlik doğrulaması başarısız oldu.',
        httpStatusCode: 401,
        technicalDetails: serverMessage,
      );
    }
    if (status == 429) {
      return AiException(
        code: AiErrorCode.rateLimitExceeded,
        message:
            'Kraliyet habercisi meşgul. Ücretsiz kota sınırına ulaşıldı, lütfen biraz sonra tekrar deneyin.',
        httpStatusCode: 429,
        technicalDetails: serverMessage,
      );
    }
    if (status >= 500) {
      return AiException(
        code: AiErrorCode.serverError,
        message:
            'Sunucu tarafında geçici bir aksaklık oluştu ($status). Lütfen daha sonra tekrar deneyin.',
        httpStatusCode: status,
        technicalDetails: serverMessage,
      );
    }
    return AiException(
      code: AiErrorCode.unknown,
      message:
          serverMessage ?? 'Beklenmeyen bir sunucu yanıtı alındı ($status).',
      httpStatusCode: status,
      technicalDetails: serverMessage,
    );
  }
}
