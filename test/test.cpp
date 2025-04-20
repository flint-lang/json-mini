#include "json/lexer.hpp"
#include <filesystem>
#include <iostream>
#include <json/parser.hpp>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "Expected one path argument!" << std::endl;
        return 1;
    }
    std::string file_str = std::string(argv[1]);
    std::filesystem::path cwd = std::filesystem::current_path();
    if (file_str.substr(0, 2) == "./") {
        file_str.erase(0, 2);
    }
    std::filesystem::path file_path = cwd / file_str;

    std::vector<JsonToken> tokens = JsonLexer::scan(file_path);
    JsonLexer::print_tokens(tokens);
    std::optional<std::unique_ptr<JsonObject>> object = JsonParser::parse(tokens);
    if (!object.has_value()) {
        std::cout << "Failed to create JsonObject" << std::endl;
        return 1;
    }
    JsonParser::print_json_object(object.value().get());
    return 0;
}
