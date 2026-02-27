/**
 * opencode plugin: session-scoped sticky routing headers for right.codes.
 *
 * Injects HTTP headers via `input.model.headers` so upstream proxies/load
 * balancers can keep a conversation pinned to one account.
 *
 * Headers injected for @ai-sdk/openai providers:
 * - x-session-id
 * - conversation_id
 * - session_id
 *
 * Source of truth (in order):
 * - env: OPENCODE_PROMPT_CACHE_KEY (manual override)
 * - env: OPENCODE_STICKY_SESSION_ID (manual override)
 * - model headers (x-session-id / conversation_id / session_id)
 * - opencode sessionID (default)
 */
export const SessionIdHeaderPlugin = async () => {
  return {
    "chat.params": async (input, output) => {
      const npm = typeof input?.provider?.info?.npm === "string" ? input.provider.info.npm : "";
      if (!npm.includes("@ai-sdk/openai")) return;

      const envSticky =
        typeof process?.env?.OPENCODE_STICKY_SESSION_ID === "string" ? process.env.OPENCODE_STICKY_SESSION_ID : "";
      const envCacheKey =
        typeof process?.env?.OPENCODE_PROMPT_CACHE_KEY === "string" ? process.env.OPENCODE_PROMPT_CACHE_KEY : "";
      const sessionID = typeof input?.sessionID === "string" ? input.sessionID : "";

      if (!input?.model || typeof input.model !== "object") return;
      const headers =
        input.model.headers && typeof input.model.headers === "object"
          ? input.model.headers
          : (input.model.headers = {});
      const headerValue = [headers["x-session-id"], headers["conversation_id"], headers["session_id"]]
        .find((v) => typeof v === "string" && v.trim())
        ?.trim?.();

      const value = (envCacheKey || envSticky || headerValue || sessionID).trim();
      if (!value) return;

      headers["x-session-id"] = value;
      headers["conversation_id"] = value;
      headers["session_id"] = value;
    },
  };
};

export default SessionIdHeaderPlugin;
