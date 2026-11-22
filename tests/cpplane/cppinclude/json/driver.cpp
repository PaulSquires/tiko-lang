// cppinclude/json, called from C++: nlohmann/json's README -- building a document by key,
// arrays and objects, dump(), parse(), typed get<>, iteration over values and over items(), an
// exception from at(). The tiko driver must print the same.
#include "lib.hpp"
#include <exception>
#include <string>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

using json = nlohmann::json;

int main() {
    // README: "JSON as first-class data type"
    json j;
    j["pi"] = 3.141;
    j["happy"] = true;
    j["name"] = "Niels";
    j["nothing"] = nullptr;
    j["answer"]["everything"] = 42;
    json list = json::array();
    list.push_back(1); list.push_back(0); list.push_back(2);
    j["list"] = list;
    json object = json::object();
    object["currency"] = "USD";
    object["value"] = 42.99;
    j["object"] = object;
    show_s("dump", j.dump().c_str());
    show_s("dump.4", j["object"].dump(4).c_str());
    show_u("size", j.size());
    show_i("is_object", j.is_object());
    show_s("type_name", j["list"].type_name());
    show_i("contains", j.contains("happy"));
    show_i("contains.not", j.contains("sad"));
    // README: "Serialization / Deserialization"
    json j2 = json::parse("{\"happy\": true, \"pi\": 3.141, \"tags\": [\"a\", \"b\"]}");
    show_d("parse.pi", j2["pi"].get<double>());
    show_i("parse.happy", j2["happy"].get<bool>());
    show_s("parse.tag", j2["tags"][1].get<std::string>().c_str());
    show_i("answer", j["answer"]["everything"].get<int>());
    // README: iterating
    long long sum = 0;
    for (auto& el : j["list"]) sum += el.get<int>();
    show_i("each.sum", sum);
    std::string keys;
    for (auto& [key, value] : j2.items()) keys += key + "=" + value.dump() + ";";
    show_s("items", keys.c_str());
    // an exception
    try { j.at("missing"); show_s("at", "no throw"); }
    catch (const std::exception& e) { show_s("at", (std::string("C++ exception: ") + e.what()).c_str()); }
    return 0;
}
