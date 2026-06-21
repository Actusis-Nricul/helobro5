print("printer started, please wait 5 seconds 😇")
wait(5)

-- Lowercase alphabet
for i = string.byte("a"), string.byte("z") do
    print(string.char(i))
end

-- Uppercase alphabet
for i = string.byte("A"), string.byte("Z") do
    print(string.char(i))
end

-- Numbers
for i = 0, 9 do
    print(i)
end

-- Common special characters
local specialChars = {
    "!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
    "-", "_", "=", "+", "[", "]", "{", "}", "\\", "|",
    ";", ":", "'", "\"", ",", ".", "<", ">", "/", "?",
    "`", "~"
}

for _, char in ipairs(specialChars) do
    print(char)
end

-- Face emojis
local emojis = {
    "😀", "😃", "😄", "😁", "😆", "🥹", "😅", "😂", "🤣", "🥲"
}

for _, emoji in ipairs(emojis) do
    print(emoji)
end

print("printer finished ✅")