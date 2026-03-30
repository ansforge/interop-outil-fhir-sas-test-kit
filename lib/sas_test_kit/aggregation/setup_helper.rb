module MyTestKit
  module SetupHelper
    # Calcule les dates de recherche (début et fin)
    def self.calculate_date_range
        ENV['TZ'] = 'Europe/Paris'
        puts "TIME NOW : #{Time.now.strftime("%Y-%m-%dT%H:%M:%S")}"
        formatted_start_date = Time.now.strftime("%Y-%m-%dT%H:%M:%S")
        three_days_later = Time.now + (3 * 24 * 60 * 60)
        max_limit = Time.now + (72 * 60 * 60)
        end_of_third_day = (Time.now + (2 * 24 * 60 * 60)).end_of_day rescue Time.new(Time.now.year, Time.now.month, Time.now.day + 2, 23, 59, 59)
        capped_time = [three_days_later, max_limit, end_of_third_day].min
        formatted_end_date = capped_time.strftime("%Y-%m-%dT%H:%M:%S")
        
        { start: formatted_start_date, end: formatted_end_date }
    end

    def self.format_practitioner_id(practitioner_id, practitioner_id_opt = nil)
        if practitioner_id_opt && !practitioner_id_opt.empty?
            "urn:oid:1.2.250.1.71.4.2.1|#{practitioner_id},urn:oid:1.2.250.1.71.4.2.1|#{practitioner_id_opt}"
        else
            "urn:oid:1.2.250.1.71.4.2.1|#{practitioner_id}"
        end
    end

    # Construit les paramètres FHIR pour la recherche Slot
    def self.build_slot_search_params(formatted_id, date_range, ig_launch)
        if ig_launch == 'ig_launch_1'   
            hash = {
                _include: 'Slot:schedule',
                '_include:iterate': 'Schedule:actor',
                'schedule.actor:Practitioner.identifier': "#{formatted_id}",
                start: ["ge#{date_range[:start]}.000+00:00", "le#{date_range[:end]}.000+00:00"],
                status: 'free'
            }
        elsif ig_launch == 'ig_launch_2'
            hash =  {
            _include: [
            'Slot:schedule',
            'Slot:service-type-reference'
            ],
            '_include:iterate': [
            'Schedule:actor',
            'HealthcareService:organization'
            ],
            'schedule.actor:Practitioner.identifier': "#{formatted_id}",
            start: ["ge#{date_range[:start]}.000", "le#{date_range[:end]}.000"],
            status: 'free'
            }
        end
        hash
    end
  end
end