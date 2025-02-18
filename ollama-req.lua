-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-------- Luci4 util to interact with Ollama ---------
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------

-- setting the local path so the script can find dependencies
local script_path = debug.getinfo(1, "S").source:match("(.*/)") or ""
script_path = script_path:sub(2)  -- Removes the '@' at the beginning if it exists
local script_dir = script_path:match("(.+)/")  -- Get everything before the last '/'
script_dir = script_dir or ""  -- If no directory, make it an empty string
package.path = script_dir .. "/?.lua;" .. package.path

local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson")

function parseArguments()
    local model, prompt, server = nil, nil, nil
    for i = 1, #arg do
        if arg[i] == "-m" then
            model = arg[i + 1]
        elseif arg[i] == "-q" then
            prompt = arg[i + 1]
        elseif arg[i] == "-s" then
            server = arg[i + 1]
        end
    end
    if model == nil then model = "smollm2:135m" end
    if server == nil then server = "localhost" end
    return model, prompt, server
end

function makeRequest(model, prompt, server)
    local request_body = '{"model": "' .. model ..  '", "prompt": "'.. prompt ..'", "stream": false}'
    
    local response_body = {}

    local res, code, response_headers, status = http.request{
        url = "http://" .. server .. ":11434/api/generate",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#request_body)
        },
        source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body),
        timeout = 600
    }

    if code == 200 then
        return table.concat(response_body), code, status
    else
        return nil, code, status
    end
end

function parseResponse(response)
    local obj, pos, err = json.decode(response, 1, nil)
    if err then
        print("Error parsing JSON:", err)
        return nil
    end
    return obj
end

function askOllama(model, prompt, server)
    local response, code, status = makeRequest(model, prompt, server)
    return parseResponse(response)
end

local model, prompt, server = parseArguments()

if (prompt ~= nil) then
    local response, code, status = makeRequest(model, prompt, server)

    if response then
        -- print("Response received: ", response)
        local parsed_data = parseResponse(response)

        if parsed_data then
            print("Model: " .. parsed_data.model)
            print("Created At: " .. parsed_data.created_at)
            print("Response: " .. parsed_data.response)
            print("Done: " .. tostring(parsed_data.done))
        end
    else
        if status == nil then status = "nil" end
        print("Error making request, status="..status..". Code="..code)
    end
end

return {
    askOllama = askOllama
}

