// cppinclude/tinyxml2, called from C++: tinyxml2's own xmltest.cpp examples 2-4 (parse a
// document, read an element's text, read an attribute and a text as int), a parse error, and a
// document built and printed. The tiko driver must print the same.
#include "lib.hpp"
extern "C" void show_i(const char*, long long);
extern "C" void show_u(const char*, unsigned long long);
extern "C" void show_d(const char*, double);
extern "C" void show_s(const char*, const char*);

using namespace tinyxml2;

static const char* PLAY =
    "<?xml version=\"1.0\"?>"
    "<!DOCTYPE PLAY SYSTEM \"play.dtd\">"
    "<PLAY>"
    "<TITLE>A Midsummer Night's Dream</TITLE>"
    "</PLAY>";

static void example_2() {
    XMLDocument doc;
    doc.Parse(PLAY);
    show_i("example_2.error", doc.ErrorID());
}

static void example_3() {
    XMLDocument doc;
    doc.Parse(PLAY);
    XMLElement* titleElement = doc.FirstChildElement("PLAY")->FirstChildElement("TITLE");
    show_s("example_3.title", titleElement->GetText());
    XMLText* textNode = titleElement->FirstChild()->ToText();
    show_s("example_3.text", textNode->Value());
}

static void example_4() {
    static const char* xml =
        "<information>"
        "    <attributeApproach v='2' />"
        "    <textApproach>"
        "        <v>2</v>"
        "    </textApproach>"
        "</information>";
    XMLDocument doc;
    doc.Parse(xml);
    int v0 = 0, v1 = 0;
    XMLElement* attributeApproachElement = doc.FirstChildElement()->FirstChildElement("attributeApproach");
    attributeApproachElement->QueryIntAttribute("v", &v0);
    XMLElement* textApproachElement = doc.FirstChildElement()->FirstChildElement("textApproach");
    textApproachElement->FirstChildElement("v")->QueryIntText(&v1);
    show_i("example_4.v0", v0);
    show_i("example_4.v1", v1);
    show_i("example_4.same", v0 == v1);
}

static void broken() {
    XMLDocument doc;
    XMLError e = doc.Parse("<a><b></a>");
    show_i("broken.error", e);
    show_s("broken.name", doc.ErrorName());
    show_i("broken.line", doc.ErrorLineNum());
}

static void build() {
    XMLDocument doc;
    XMLNode* root = doc.NewElement("library");
    doc.InsertFirstChild(root);
    const char* titles[] = { "Dune", "Emma", "Ulysses" };
    for (int i = 0; i < 3; ++i) {
        XMLElement* book = doc.NewElement("book");
        book->SetAttribute("id", i + 1);
        book->SetAttribute("title", titles[i]);
        book->SetText(1965.5 + i);
        root->InsertEndChild(book);
    }
    XMLElement* last = root->LastChildElement("book");
    show_i("build.last.id", last->IntAttribute("id"));
    show_d("build.last.text", last->DoubleText());
    show_i("build.count", root->ToElement()->ChildElementCount());
    XMLPrinter printer;
    doc.Print(&printer);
    show_s("build.xml", printer.CStr());
    XMLPrinter compact(nullptr, true);
    doc.Print(&compact);
    show_s("build.compact", compact.CStr());
    show_i("build.size", compact.CStrSize());
}

int main() {
    example_2();
    example_3();
    example_4();
    broken();
    build();
    return 0;
}
