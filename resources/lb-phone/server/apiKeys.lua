local DISCORD_WEBHOOK_URL = GetConvar("lb-phone-media", "")
local MEDIA_API_KEY = GetConvar("lb-phone-media-api-key", "")
local WALLET_DISCORD_WEBHOOK_URL = GetConvar("lb-phone-wallet-webhook", "")

-- Webhook for instapic posts, recommended to be a public channel
INSTAPIC_WEBHOOK = DISCORD_WEBHOOK_URL
-- Webhook for birdy posts, recommended to be a public channel
BIRDY_WEBHOOK = DISCORD_WEBHOOK_URL

-- Discord webhook for server logs
LOGS = {
    Calls = DISCORD_WEBHOOK_URL, -- set to false to disable
    Messages = DISCORD_WEBHOOK_URL,
    InstaPic = DISCORD_WEBHOOK_URL,
    Birdy = DISCORD_WEBHOOK_URL,
    YellowPages = DISCORD_WEBHOOK_URL,
    Marketplace = DISCORD_WEBHOOK_URL,
    Mail = DISCORD_WEBHOOK_URL,
    Wallet = WALLET_DISCORD_WEBHOOK_URL,
    DarkChat = DISCORD_WEBHOOK_URL,
    Services = DISCORD_WEBHOOK_URL,
    Crypto = DISCORD_WEBHOOK_URL,
    Trendy = DISCORD_WEBHOOK_URL
}

-- Set your API keys for uploading media here. 
-- Please note that the API key needs to match the correct upload method defined in Config.UploadMethod.
-- The default upload method is Fivemanage
-- We STRONGLY discourage using Discord as an upload method, as uploaded files may become inaccessible after a while.
-- You can get your API keys from https://fivemanage.com/
-- A video tutorial for how to set up Fivemanage can be found here: https://www.youtube.com/watch?v=y3bCaHS6Moc
API_KEYS = {
    Video = MEDIA_API_KEY,
    Image = MEDIA_API_KEY,
    Audio = MEDIA_API_KEY,
}
