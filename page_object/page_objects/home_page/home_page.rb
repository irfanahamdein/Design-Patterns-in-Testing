class HomePage < Page
  def page_path
    "/"
  end
  
  def body
    nil
  end
  
  def special_places
    @selenium.find_elements(:class, ".arrow_text a[href*="Attraction"].more-info").collect do |element|
       SpecialItem.new(element, @selenium)
    end
  end
  
  
  def recent_places
     #Implement me
  end
  
end
            
