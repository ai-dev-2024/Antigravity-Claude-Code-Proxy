/**
 * Preloaded into the proxy (node --import): Google's OAuth token endpoint answers every
 * refresh with the HTTP status given in TEST_GOOGLE_TOKEN_STATUS. With TEST_GOOGLE_TOKEN_ERROR
 * the body is an OAuth error response (RFC 6749 section 5.2), e.g. invalid_grant or
 * invalid_client; without it the body is plain text. Every other request goes through untouched.
 */
const realFetch = globalThis.fetch;
const status = Number(process.env.TEST_GOOGLE_TOKEN_STATUS);
const oauthError = process.env.TEST_GOOGLE_TOKEN_ERROR;
const body = oauthError
    ? JSON.stringify({ error: oauthError, error_description: `mock ${oauthError} answer` })
    : 'Service Unavailable';

globalThis.fetch = (input, init) => {
    const url = typeof input === 'string' ? input : input.url;
    if (String(url).startsWith('https://oauth2.googleapis.com/')) {
        // A fresh Response per call: a body can only be read once
        return Promise.resolve(new Response(body, { status }));
    }
    return realFetch(input, init);
};
