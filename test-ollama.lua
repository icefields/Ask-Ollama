local ollama = require("ollama-req")

local parsed_data = ollama.askOllama("smollm2:135m", "tell me about calico cats", "192.168.1.77")

print("Model: " .. parsed_data.model)
print("Created At: " .. parsed_data.created_at)
print("Response: " .. parsed_data.response)
print("Done: " .. tostring(parsed_data.done))

