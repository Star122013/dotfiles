/**
 * opencode plugin: set a session-scoped prompt cache key.
 *
 * Source of truth (in order):
 * - env: OPENCODE_PROMPT_CACHE_KEY (manual override)
 * - env: OPENCODE_STICKY_SESSION_ID (manual override)
 * - model headers (x-session-id / conversation_id / session_id)
 * - opencode sessionID (default)
 */
export const FixedPromptCacheKeyPlugin = async () => {
  return {
    "chat.params": async (input, output) => {
      const npm = typeof input?.provider?.info?.npm === "string" ? input.provider.info.npm : "";
      if (!npm.includes("@ai-sdk/openai")) return;

      const envKey =
        typeof process?.env?.OPENCODE_PROMPT_CACHE_KEY === "string" ? process.env.OPENCODE_PROMPT_CACHE_KEY : "";
      const envSticky =
        typeof process?.env?.OPENCODE_STICKY_SESSION_ID === "string" ? process.env.OPENCODE_STICKY_SESSION_ID : "";
      const sessionID = typeof input?.sessionID === "string" ? input.sessionID : "";

      const headers = input?.model?.headers && typeof input.model.headers === "object" ? input.model.headers : {};
      const headerValue = [headers["x-session-id"], headers["conversation_id"], headers["session_id"]]
        .find((v) => typeof v === "string" && v.trim())
        ?.trim?.();
      const value = (envKey || envSticky || headerValue || sessionID).trim();
      if (!value) return;

      const existing = output?.options && typeof output.options === "object" ? output.options : {};
      output.options = {
        ...existing,
        promptCacheKey: value,
      };
    },
  };
};

export default FixedPromptCacheKeyPlugin;
