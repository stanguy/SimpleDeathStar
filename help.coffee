
$(document).ready ->
        $('dt').click (e) ->
                son = $(e.currentTarget).next('dd')
                add_class = true
                if son.hasClass "expanded"
                        add_class = false
                $("dd.expanded").removeClass "expanded"
                if add_class
                      son.addClass "expanded"