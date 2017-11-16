require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    student_array = []

    doc.css(".student-card").each do |stud|
      student_array << {
        name: stud.css("h4").first.text,
        location: stud.css("p").first.text,
        profile_url: stud.css("a").attribute("href").value
      }
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    profile = {}

    container = doc.css(".social-icon-container")
    profile_name = doc.css(".profile-name").text.split.first.downcase

    container.each do |tab|
      i = 0
      if tab.css("a")[i].attribute("href").value.include?("twitter")
        profile[:twitter] = container.css("a")[i].attribute("href").value
        i += 1
      end
      if tab.css("a")[i].attribute("href").value.include?("linkedin")
        profile[:linkedin] = container.css("a")[i].attribute("href").value
        i += 1
      end
      if tab.css("a")[i].attribute("href").value.include?("git")
        profile[:github] = container.css("a")[i].attribute("href").value
        i += 1
      end
      unless container.css("a")[i] == nil
        profile[:blog] = container.css("a")[i].attribute("href").value
      end
    end
    profile[:profile_quote] = doc.css(".profile-quote").text
    profile[:bio] = doc.css(".description-holder").css("p").text
    profile
  end

end
