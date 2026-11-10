/**
 * Preloaded into the proxy (node --import): Google's OAuth token endpoint answers every
 * refresh with the HTTP status given in TEST_GOOGLE_TOKEN_STATUS (e.g. 503, 429 or a
 * 400 invalid_grant); every other request goes through untouched.
 */
const realFetch = globalThis.fetch;
const status = Number(process.env.TEST_GOOGLE_TOKEN_STATUS);
const body = status === 400
    ? JSON.stringify({ error: 'invalid_grant', error_description: 'Token has been expired or revoked.' })
    : 'Service Unavailable';

globalThis.fetch = (input, init) => {
    const url = typeof input === 'string' ? input : input.url;
    if (String(url).startsWith('https://oauth2.googleapis.com/')) {
        // A fresh Response per call: a body can only be read once
        return Promise.resolve(new Response(body, { status }));
    }
    return realFetch(input, init);
};
