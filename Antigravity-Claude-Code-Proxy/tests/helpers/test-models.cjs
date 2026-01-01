/**
 * Test Models Configuration
 *
 * Provides model configuration for parameterized testing across
 * multiple model families (Claude and Gemini).
 */

// Default test models for each family
const TEST_MODELS = {
    claude: 'claude-sonnet-4-5-thinking',
    gemini: 'gemini-3-flash'
};

// Default thinking model for each family
const THINKING_MODELS = {
    claude: 'claude-sonnet-4-5-thinking',
    gemini: 'gemini-3-flash'
};

/**
 * Get models to test, optionally excluding certain families.
 * @param {string[]} excludeFamilies - Array of family names to exclude (e.g., ['gemini'])
 * @returns {Array<{family: string, model: string}>} Array of model configs to test
 */
function getTestModels(excludeFamilies = []) {
    const models = [];
    for (const [family, model] of Object.entries(TEST_MODELS)) {
        if (!excludeFamilies.includes(family)) {
            models.push({ family, model });
        }
    }
    return models;
}

/**
 * Get thinking models to test, optionally excluding certain families.
 * @param {string[]} excludeFamilies - Array of family names to exclude
 * @returns {Array<{family: string, model: string}>} Array of thinking model configs
 */
function getThinkingModels(excludeFamilies = []) {
    const models = [];
    for (const [family, model] of Object.entries(THINKING_MODELS)) {
        if (!excludeFamilies.includes(family)) {
            models.push({ family, model });
        }
    }
    return models;
}

/**
 * Check if a model family requires thinking features.
 * Both Claude thinking models and Gemini 3+ support thinking.
 * @param {string} family - Model family name
 * @returns {boolean} True if thinking is expected
 */
function familySupportsThinking(family) {
    // Both Claude thinking models and Gemini 3+ support thinking
    return family === 'claude' || family === 'gemini';
}

/**
 * Get model-specific configuration overrides.
 * @param {string} family - Model family name
 * @returns {Object} Configuration overrides for the model family
 */
function getModelConfig(family) {
    if (family === 'gemini') {
        return {
            // Gemini has lower max output tokens
            max_tokens: 8000,
            thinking: { type: 'enabled', budget_tokens: 10000 }
        };
    }
    return {
        max_tokens: 16000,
        thinking: { type: 'enabled', budget_tokens: 10000 }
    };
}

module.exports = {
    TEST_MODELS,
    THINKING_MODELS,
    getTestModels,
    getThinkingModels,
    familySupportsThinking,
    getModelConfig
};
