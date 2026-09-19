[Home](Home) › [Tutorials](Category-Tutorials) › **GTK+, The GIMP ToolKit**

# GTK+, The GIMP ToolKit

Cross-platform Graphical User Interface library

 Website: http://www.gtk.org  
 Platforms supported: Win32, Linux  
 Headers to include: gtk/gtk.bi  
 Example Usage: yes, in examples/GUI/GTK+/  
 Header version: 2.24.27, 3.14.10

 By default, gtk/gtk.bi will use the GTK+ 2 API.  
 Define \_\_USE_GTK3\_\_ before including gtk/gtk.bi to use GTK+ 3.

Example

```freebasic
#include Once "gtk/gtk.bi"

Dim Shared As GtkWidget Ptr win

Private Sub on_clicked cdecl(ByVal button As GtkButton Ptr, ByVal userdata As gpointer)

    Static As Integer clickcount = 0

    clickcount += 1

    gtk_window_set_title(GTK_WINDOW(win), "clicked " & clickcount & " times")

End Sub

gtk_init(NULL, NULL)

win = gtk_window_new(GTK_WINDOW_TOPLEVEL)

gtk_window_set_title(GTK_WINDOW(win), "A small GTK+ example")

gtk_window_set_default_size(GTK_WINDOW(win), 300, 200)

gtk_container_set_border_width(GTK_CONTAINER(win), 20)

g_signal_connect(G_OBJECT(win), "destroy", G_CALLBACK(@gtk_main_quit), NULL)

Dim As GtkWidget Ptr button = gtk_button_new_with_label("Click me!")

gtk_container_add(GTK_CONTAINER(win), button)

g_signal_connect(G_OBJECT(button), "clicked", G_CALLBACK(@on_clicked), NULL)

gtk_widget_show_all(win)

gtk_main()
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
