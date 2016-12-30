module ApiHelper
    def getPageActiveCondition (page)
        if @cur_page == page
            return "active"
        end
        return ""
    end
end
