class HolidayService
  def upcoming_holidays
    get_url("/NextPublicHolidays/US")
  end 

  def get_url(url)
    response = Faraday.get("https://date.nager.at/api/v3#{url}")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end 
end 