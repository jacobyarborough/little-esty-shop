class HolidayFacade
  def upcoming_holidays
    service.upcoming_holidays.map do |data|
      Holiday.new(data)
    end 
  end 

  def service 
    HolidayService.new
  end 
end 