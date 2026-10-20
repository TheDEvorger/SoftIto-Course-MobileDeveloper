# Rule: architecture

Own domain behavior in the feature. UI must not manipulate HTTP/database directly. Domain does not import Flutter. Prefer explicit contracts and dependency inversion only where integration requires it. No god objects; no premature microservices.
