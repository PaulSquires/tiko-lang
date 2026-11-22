// cppinclude/pugixml, called from C++: pugixml's own samples -- load from a string, a parse
// error, traversing nodes and attributes, modifying a tree, XPath -- on documents held in the
// program. The tiko driver must print the same.
#include "lib.hpp"
#include <string>
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

static const char* TOOLS =
    "<Profile FormatVersion='1'>"
    "<Tools>"
    "<Tool Filename='jam' AllowRemote='true' Timeout='40'/>"
    "<Tool Filename='mayabatch.exe' AllowRemote='true' Timeout='60' DeriveCaptionFrom='lastparam'/>"
    "<Tool Filename='meshbuilder_*.exe' AllowRemote='false' Timeout='20'/>"
    "<Tool Filename='texbuilder_*.exe' AllowRemote='true' Timeout='30'/>"
    "</Tools>"
    "</Profile>";

static void load_string() {
    pugi::xml_document doc;
    pugi::xml_parse_result result = doc.load_string("<mesh name='sphere'><bounds>0 0 1 1</bounds></mesh>");
    show_s("load.result", result.description());
    show_i("load.status", result.status);
    show_s("load.mesh", doc.child("mesh").attribute("name").value());
    show_s("load.bounds", doc.child("mesh").child_value("bounds"));
}

static void load_error() {
    pugi::xml_document doc;
    pugi::xml_parse_result result = doc.load_string("<node attr='value'><child>text</chil></node>");
    show_i("error.status", result.status);
    show_s("error.description", result.description());
    show_i("error.offset", result.offset);
}

static void traverse() {
    pugi::xml_document doc;
    doc.load_string(TOOLS);
    pugi::xml_node tools = doc.child("Profile").child("Tools");
    int n = 0;
    for (pugi::xml_node tool = tools.first_child(); tool; tool = tool.next_sibling()) {
        std::string line = tool.name();
        for (pugi::xml_attribute attr = tool.first_attribute(); attr; attr = attr.next_attribute())
            line += std::string(" ") + attr.name() + "=" + attr.value();
        show_s("tool", line.c_str());
        ++n;
    }
    show_i("tools", n);
    show_i("timeout.sum", tools.find_child_by_attribute("Tool", "Filename", "jam").attribute("Timeout").as_int() +
                          tools.last_child().attribute("Timeout").as_int());
}

static void modify() {
    pugi::xml_document doc;
    doc.load_string("<node id='123'><child>text</child></node>");
    pugi::xml_node node = doc.child("node");
    show_i("modify.name", node.set_name("notnode"));
    show_s("modify.renamed", doc.first_child().name());
    pugi::xml_attribute attr = node.attribute("id");
    attr.set_value("345");
    show_i("modify.id", attr.as_int());
    node.append_attribute("version").set_value(1.25);
    show_d("modify.version", node.attribute("version").as_double());
    pugi::xml_node param = node.insert_child_before("param", node.child("child"));
    param.append_attribute("name").set_value("id");
    param.text().set(42);
    show_s("modify.first", node.first_child().name());
    show_i("modify.param", node.child("param").text().as_int());
    node.remove_child("child");
    show_i("modify.empty.child", node.child("child").empty());
}

static void xpath() {
    pugi::xml_document doc;
    doc.load_string(TOOLS);
    pugi::xpath_node tool = doc.select_node("/Profile/Tools/Tool[@AllowRemote='true' and @DeriveCaptionFrom='lastparam']");
    show_s("xpath.tool", tool.node().attribute("Filename").value());
    pugi::xpath_query sum("sum(//Tool/@Timeout)");
    show_d("xpath.sum", sum.evaluate_number(doc));
    pugi::xpath_query count("count(//Tool[@AllowRemote='true'])");
    show_d("xpath.count", count.evaluate_number(doc));
}

static void ranges() {
    // pugixml's own range-for idioms
    pugi::xml_document doc;
    doc.load_string(TOOLS);
    pugi::xml_node tools = doc.child("Profile").child("Tools");
    std::string s;
    for (pugi::xml_node tool : tools) s += std::string(tool.attribute("Filename").value()) + ";";
    show_s("each.tools", s.c_str());
    std::string a;
    for (pugi::xml_attribute attr : tools.first_child().attributes()) a += std::string(attr.name()) + ",";
    show_s("each.attributes", a.c_str());
    int n = 0;
    for (pugi::xml_node t : tools.children("Tool")) { (void)t; ++n; }
    show_i("each.named", n);
    pugi::xpath_node_set remote = doc.select_nodes("//Tool[@AllowRemote='true']");
    std::string r;
    for (pugi::xpath_node xn : remote) r += std::string(xn.node().attribute("Timeout").value()) + " ";
    show_s("each.xpath", r.c_str());
}

int main() {
    load_string();
    load_error();
    traverse();
    modify();
    xpath();
    ranges();
    return 0;
}
