module FitParser
  class File
    module Definitions
      def self.fields
        @fields ||= Hash.new { |h, k| h[k]= {} }
      end

      def self.fields=(value)
        @fields = value
      end

      def self.dyn_fields
        @dyn_fields ||= Hash.new { |h, k| h[k]= {} }
      end

      def self.dyn_fields=(value)
        @dyn_fields = value
      end

      def self.names
        @names ||= Hash.new
      end

      def self.names=(value)
        @names = value
      end

      def self.add_field(global_msg_num, field_def_num, name, options = {})
        if Definitions.fields[global_msg_num].has_key? field_def_num
          raise "bad definition of dynamic field  (#{name}) without :ref_field_name or :ref_field_values" unless options.has_key?(:ref_field_name) && options.has_key?(:ref_field_values)
          Definitions.dyn_fields[global_msg_num][field_def_num] ||= {}
          Definitions.dyn_fields[global_msg_num][field_def_num][name.to_sym] = options
          # let's put the ref_field_values with the raw_value instead of the real value
          type = Types.get_type_definition(options[:ref_field_name].to_sym) if options[:ref_field_name]
          # basic types are not found and returns nil (also some rspec dummy tests)
          if type
            type = type[:values].invert
            Definitions.dyn_fields[global_msg_num][field_def_num][name.to_sym][:ref_field_values] = options[:ref_field_values].map { |elt| type[elt.to_s] }
          end
        else
          Definitions.fields[global_msg_num][field_def_num] = options.merge(:name => name)
        end
      end

      def self.get_field(global_msg_num, field_def_num)
        Definitions.fields[global_msg_num][field_def_num]
      end

      def self.get_dynamic_fields(global_msg_num, field_def_num)
        Definitions.dyn_fields[global_msg_num][field_def_num] 
      end

      def self.add_name(global_msg_num, name)
        Definitions.names[global_msg_num] = name
      end

      def self.get_name(global_msg_num)
        Definitions.names[global_msg_num]
      end
    end
  end
end

# DATA
FitParser::File::Definitions.add_name 0, 'file_id'
FitParser::File::Definitions.add_field 0, 0, 'type', :type => :file
FitParser::File::Definitions.add_field 0, 1, 'manufacturer', :type => :manufacturer
FitParser::File::Definitions.add_field 0, 2, 'product', :type => :uint16
FitParser::File::Definitions.add_field 0, 2, 'garmin_product', :type => :garmin_product, :ref_field_name => 'manufacturer', :ref_field_values => [:garmin, :dynastream, :dynastream_oem]
FitParser::File::Definitions.add_field 0, 3, 'serial_number', :type => :uint32z
FitParser::File::Definitions.add_field 0, 4, 'time_created', :type => :date_time
FitParser::File::Definitions.add_field 0, 5, 'number', :type => :uint16

FitParser::File::Definitions.add_name 49, 'file_creator'
FitParser::File::Definitions.add_field 49, 0, 'software_version', :type => :uint16
FitParser::File::Definitions.add_field 49, 1, 'hardware_version', :type => :uint8

FitParser::File::Definitions.add_name 35, 'software'
FitParser::File::Definitions.add_field 35, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 35, 3, 'version', :type => :uint16, :scale => 100
FitParser::File::Definitions.add_field 35, 5, 'part_number', :type => :string

FitParser::File::Definitions.add_name 106, 'slave_device'
FitParser::File::Definitions.add_field 106, 0, 'manufacturer', :type => :manufacturer
FitParser::File::Definitions.add_field 106, 1, 'product', :type => :uint16
FitParser::File::Definitions.add_field 106, 1, 'garmin_product', :type => :garmin_product, :ref_field_name => 'manufacturer', :ref_field_values => [:garmin, :dynastream, :dynastream_oem]

FitParser::File::Definitions.add_name 1, 'capabilities'
FitParser::File::Definitions.add_field 1, 0, 'languages', :type => :uint8z
FitParser::File::Definitions.add_field 1, 1, 'sports', :type => :sport_bits_0
FitParser::File::Definitions.add_field 1, 21, 'workouts_supported', :type => :workout_capabilities
FitParser::File::Definitions.add_field 1, 23, 'connectivity_supported', :type => :connectivity_capabilities

FitParser::File::Definitions.add_name 37, 'file_capabilities'
FitParser::File::Definitions.add_field 37, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 37, 0, 'type', :type => :file
FitParser::File::Definitions.add_field 37, 1, 'flags', :type => :file_flags
FitParser::File::Definitions.add_field 37, 2, 'directory', :type => :string
FitParser::File::Definitions.add_field 37, 3, 'max_count', :type => :uint16
FitParser::File::Definitions.add_field 37, 4, 'max_size', :type => :uint32, :unit => 'bytes'

FitParser::File::Definitions.add_name 38, 'mesg_capabilities'
FitParser::File::Definitions.add_field 38, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 38, 0, 'file', :type => :file
FitParser::File::Definitions.add_field 38, 1, 'mesg_num', :type => :mesg_num
FitParser::File::Definitions.add_field 38, 2, 'count_type', :type => :mesg_count
FitParser::File::Definitions.add_field 38, 3, 'count', :type => :uint16
FitParser::File::Definitions.add_field 38, 3, 'num_per_file', :type => :uint16, :ref_field_name => 'count_type', :ref_field_values => [:num_per_file]
FitParser::File::Definitions.add_field 38, 3, 'max_per_file', :type => :uint16, :ref_field_name => 'count_type', :ref_field_values => [:max_per_file]
FitParser::File::Definitions.add_field 38, 3, 'max_per_file_type', :type => :uint16, :ref_field_name => 'count_type', :ref_field_values => [:max_per_file_type]

FitParser::File::Definitions.add_name 39, 'field_capabilities'
FitParser::File::Definitions.add_field 39, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 39, 0, 'file', :type => :file
FitParser::File::Definitions.add_field 39, 1, 'mesg_num', :type => :mesg_num
FitParser::File::Definitions.add_field 39, 2, 'field_num', :type => :uint8
FitParser::File::Definitions.add_field 39, 3, 'count', :type => :uint16

FitParser::File::Definitions.add_name 2, 'device_settings'
FitParser::File::Definitions.add_field 2, 0, 'active_time_zone', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 2, 1, 'utc_offset', :type => :uint32
FitParser::File::Definitions.add_field 2, 5, 'time_zone_offset', :type => :sint8, :scale => 4, :unit => 'hr'

FitParser::File::Definitions.add_name 3, 'user_profile'
FitParser::File::Definitions.add_field 3, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 3, 0, 'friendly_name', :type => :string, :scale => 1
FitParser::File::Definitions.add_field 3, 1, 'gender', :type => :gender, :scale => 1
FitParser::File::Definitions.add_field 3, 2, 'age', :type => :uint8, :scale => 1, :unit => 'years'
FitParser::File::Definitions.add_field 3, 3, 'height', :type => :uint8, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 3, 4, 'weight', :type => :uint16, :scale => 10, :unit => 'kg'
FitParser::File::Definitions.add_field 3, 5, 'language', :type => :language, :scale => 1
FitParser::File::Definitions.add_field 3, 6, 'elev_setting', :type => :display_measure, :scale => 1
FitParser::File::Definitions.add_field 3, 7, 'weight_setting', :type => :display_measure, :scale => 1
FitParser::File::Definitions.add_field 3, 8, 'resting_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 3, 9, 'default_max_running_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 3, 10, 'default_max_biking_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 3, 11, 'default_max_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 3, 12, 'hr_setting', :type => :display_heart, :scale => 1
FitParser::File::Definitions.add_field 3, 13, 'speed_setting', :type => :display_measure, :scale => 1
FitParser::File::Definitions.add_field 3, 14, 'dist_setting', :type => :display_measure, :scale => 1
FitParser::File::Definitions.add_field 3, 16, 'power_setting', :type => :display_power, :scale => 1
FitParser::File::Definitions.add_field 3, 17, 'activity_class', :type => :activity_class, :scale => 1
FitParser::File::Definitions.add_field 3, 18, 'position_setting', :type => :display_position, :scale => 1
FitParser::File::Definitions.add_field 3, 21, 'temperature_setting', :type => :display_measure, :scale => 1
FitParser::File::Definitions.add_field 3, 22, 'local_id', :type => :user_local_id
FitParser::File::Definitions.add_field 3, 23, 'global_id', :type => :byte
FitParser::File::Definitions.add_field 3, 30, 'height_setting', :type => :display_measure

FitParser::File::Definitions.add_name 4, 'hrm_profile'
FitParser::File::Definitions.add_field 4, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 4, 0, 'enabled', :type => :bool
FitParser::File::Definitions.add_field 4, 1, 'hrm_ant_id', :type => :uint16z, :scale => 1
FitParser::File::Definitions.add_field 4, 2, 'log_hrv', :type => :bool
FitParser::File::Definitions.add_field 4, 3, 'hrm_ant_id_trans_type', :type => :uint8z

FitParser::File::Definitions.add_name 5, 'sdm_profile'
FitParser::File::Definitions.add_field 5, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 5, 0, 'enabled', :type => :bool
FitParser::File::Definitions.add_field 5, 1, 'sdm_ant_id', :type => :uint16z, :scale => 1
FitParser::File::Definitions.add_field 5, 2, 'sdm_cal_factor', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 5, 3, 'odometer', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 5, 4, 'speed_source', :type => :bool
FitParser::File::Definitions.add_field 5, 5, 'sdm_ant_id_trans_type', :type => :uint8z
FitParser::File::Definitions.add_field 5, 7, 'odometer_rollover', :type => :uint8

FitParser::File::Definitions.add_name 6, 'bike_profile'
FitParser::File::Definitions.add_field 6, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 6, 0, 'name', :type => :string, :scale => 1
FitParser::File::Definitions.add_field 6, 1, 'sport', :type => :sport, :scale => 1
FitParser::File::Definitions.add_field 6, 2, 'sub_sport', :type => :sub_sport, :scale => 1
FitParser::File::Definitions.add_field 6, 3, 'odometer', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 6, 4, 'bike_spd_ant_id', :type => :uint16z, :scale => 1
FitParser::File::Definitions.add_field 6, 5, 'bike_cad_ant_id', :type => :uint16z, :scale => 1
FitParser::File::Definitions.add_field 6, 6, 'bike_spdcad_ant_id', :type => :uint16z, :scale => 1
FitParser::File::Definitions.add_field 6, 7, 'bike_power_ant_id', :type => :uint16z, :scale => 1
FitParser::File::Definitions.add_field 6, 8, 'custom_wheelsize', :type => :uint16, :scale => 1000, :unit => 'm'
FitParser::File::Definitions.add_field 6, 9, 'auto_wheelsize', :type => :uint16, :scale => 1000, :unit => 'm'
FitParser::File::Definitions.add_field 6, 10, 'bike_weight', :type => :uint16, :scale => 10, :unit => 'kg'
FitParser::File::Definitions.add_field 6, 11, 'power_cal_factor', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 6, 12, 'auto_wheel_cal', :type => :bool, :scale => 1
FitParser::File::Definitions.add_field 6, 13, 'auto_power_zero', :type => :bool, :scale => 1
FitParser::File::Definitions.add_field 6, 14, 'id', :type => :uint8
FitParser::File::Definitions.add_field 6, 15, 'spd_enabled', :type => :bool
FitParser::File::Definitions.add_field 6, 16, 'cad_enabled', :type => :bool
FitParser::File::Definitions.add_field 6, 17, 'spdcad_enabled', :type => :bool
FitParser::File::Definitions.add_field 6, 18, 'power_enabled', :type => :bool
FitParser::File::Definitions.add_field 6, 19, 'crank_length', :type => :uint8, :scale => 2, :offset => -110, :unit => 'mm'
FitParser::File::Definitions.add_field 6, 20, 'enabled', :type => :bool
FitParser::File::Definitions.add_field 6, 21, 'bike_spd_ant_id_trans_type', :type => :uint8z
FitParser::File::Definitions.add_field 6, 22, 'bike_cad_ant_id_trans_type', :type => :uint8z
FitParser::File::Definitions.add_field 6, 23, 'bike_spdcad_ant_id_trans_type', :type => :uint8z
FitParser::File::Definitions.add_field 6, 24, 'bike_power_ant_id_trans_type', :type => :uint8z
FitParser::File::Definitions.add_field 6, 37, 'odometer_rollover', :type => :uint8
FitParser::File::Definitions.add_field 6, 38, 'front_gear_num', :type => :uint8z
FitParser::File::Definitions.add_field 6, 39, 'front_gear', :type => :uint8z
FitParser::File::Definitions.add_field 6, 40, 'rear_gear_num', :type => :uint8z
FitParser::File::Definitions.add_field 6, 41, 'rear_gear', :type => :uint8z

FitParser::File::Definitions.add_name 7, 'zones_target'
FitParser::File::Definitions.add_field 7, 1, 'max_heart_rate', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 7, 2, 'threshold_heart_rate', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 7, 3, 'functional_threshold_power', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 7, 5, 'hr_calc_type', :type => :hr_zone_calc, :scale => 1
FitParser::File::Definitions.add_field 7, 7, 'pwr_calc_type', :type => :pwr_zone_calc, :scale => 1

FitParser::File::Definitions.add_name 12, 'sport'
FitParser::File::Definitions.add_field 12, 0, 'sport', :type => :sport, :scale => 1
FitParser::File::Definitions.add_field 12, 1, 'sub_sport', :type => :sub_sport, :scale => 1
FitParser::File::Definitions.add_field 12, 3, 'name', :type => :string

FitParser::File::Definitions.add_name 8, 'hr_zone'
FitParser::File::Definitions.add_field 8, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 8, 1, 'high_bpm', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 8, 2, 'name', :type => :string, :scale => 1

FitParser::File::Definitions.add_name 53, 'speed_zone'
FitParser::File::Definitions.add_field 53, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 53, 0, 'high_value', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 53, 1, 'name', :type => :string, :scale => 1

FitParser::File::Definitions.add_name 131, 'cadence_zone'
FitParser::File::Definitions.add_field 131, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 131, 0, 'high_value', :type => :uint8, :scale => 1, :unit => 'rpm'
FitParser::File::Definitions.add_field 131, 1, 'name', :type => :string, :scale => 1

FitParser::File::Definitions.add_name 9, 'power_zone'
FitParser::File::Definitions.add_field 9, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 9, 1, 'high_value', :type => :uint16, :scale => 1, :unit => 'watts'
FitParser::File::Definitions.add_field 9, 2, 'name', :type => :string, :scale => 1

FitParser::File::Definitions.add_name 10, 'met_zone'
FitParser::File::Definitions.add_field 10, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 10, 1, 'high_bpm', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 10, 2, 'calories', :type => :uint16, :scale => 10, :unit => 'kcal / min'
FitParser::File::Definitions.add_field 10, 3, 'fat_calories', :type => :uint8, :scale => 10, :unit => 'kcal / min'

FitParser::File::Definitions.add_name 15, 'goal'
FitParser::File::Definitions.add_field 15, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 15, 0, 'sport', :type => :sport, :scale => 1
FitParser::File::Definitions.add_field 15, 1, 'sub_sport', :type => :sub_sport, :scale => 1
FitParser::File::Definitions.add_field 15, 2, 'start_date', :type => :date_time
FitParser::File::Definitions.add_field 15, 3, 'end_date', :type => :date_time
FitParser::File::Definitions.add_field 15, 4, 'type', :type => :goal
FitParser::File::Definitions.add_field 15, 5, 'value', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 15, 6, 'repeat', :type => :bool
FitParser::File::Definitions.add_field 15, 7, 'target_value', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 15, 8, 'recurrence', :type => :goal_recurrence, :scale => 1
FitParser::File::Definitions.add_field 15, 9, 'recurrence_value', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 15, 10, 'enabled', :type => :bool, :scale => 1

FitParser::File::Definitions.add_name 34, 'activity'
FitParser::File::Definitions.add_field 34, 253, 'timestamp', :type => :date_time
FitParser::File::Definitions.add_field 34, 0, 'total_timer_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 34, 1, 'num_sessions', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 34, 2, 'type', :type => :activity
FitParser::File::Definitions.add_field 34, 3, 'event', :type => :event
FitParser::File::Definitions.add_field 34, 4, 'event_type', :type => :event_type
FitParser::File::Definitions.add_field 34, 5, 'local_timestamp', :type => :local_date_time
FitParser::File::Definitions.add_field 34, 6, 'event_group', :type => :uint8

FitParser::File::Definitions.add_name 18, 'session'
FitParser::File::Definitions.add_field 18, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 18, 253, 'timestamp', :type => :date_time, :unit => 's'
FitParser::File::Definitions.add_field 18, 0, 'event', :type => :event
FitParser::File::Definitions.add_field 18, 1, 'event_type', :type => :event_type
FitParser::File::Definitions.add_field 18, 2, 'start_time', :type => :date_time, :scale => 1
FitParser::File::Definitions.add_field 18, 3, 'start_position_lat', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 18, 4, 'start_position_long', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 18, 5, 'sport', :type => :sport, :scale => 1
FitParser::File::Definitions.add_field 18, 6, 'sub_sport', :type => :sub_sport, :scale => 1
FitParser::File::Definitions.add_field 18, 7, 'total_elapsed_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 8, 'total_timer_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 9, 'total_distance', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 18, 10, 'total_cycles', :type => :uint32, :scale => 1, :unit => 'cycles'
FitParser::File::Definitions.add_field 18, 10, 'total_strides', :type => :uint32, :scale => 1, :unit => 'strides', :ref_field_name => 'sport', :ref_field_values => [:running]
FitParser::File::Definitions.add_field 18, 11, 'total_calories', :type => :uint16, :scale => 1, :unit => 'kcal'
FitParser::File::Definitions.add_field 18, 13, 'total_fat_calories', :type => :uint16, :scale => 1, :unit => 'kcal'
FitParser::File::Definitions.add_field 18, 14, 'avg_speed', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 15, 'max_speed', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 16, 'avg_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 18, 17, 'max_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 18, 18, 'avg_cadence', :type => :uint8, :scale => 1, :unit => 'rpm'
FitParser::File::Definitions.add_field 18, 18, 'avg_running_cadence', :type => :uint8, :scale => 1, :unit => 'strides/min', :ref_field_name => 'sport', :ref_field_values => [:running]
FitParser::File::Definitions.add_field 18, 19, 'max_cadence', :type => :uint8, :scale => 1, :unit => 'rpm'
FitParser::File::Definitions.add_field 18, 18, 'max_running_cadence', :type => :uint8, :scale => 1, :unit => 'strides/min', :ref_field_name => 'sport', :ref_field_values => [:running]
FitParser::File::Definitions.add_field 18, 20, 'avg_power', :type => :uint16, :scale => 1, :unit => 'watts'
FitParser::File::Definitions.add_field 18, 21, 'max_power', :type => :uint16, :scale => 1, :unit => 'watts'
FitParser::File::Definitions.add_field 18, 22, 'total_ascent', :type => :uint16, :scale => 1, :unit => 'm'
FitParser::File::Definitions.add_field 18, 23, 'total_descent', :type => :uint16, :scale => 1, :unit => 'm'
FitParser::File::Definitions.add_field 18, 24, 'total_training_effect', :type => :uint8, :scale => 10
FitParser::File::Definitions.add_field 18, 25, 'first_lap_index', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 18, 26, 'num_laps', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 18, 27, 'event_group', :type => :uint8
FitParser::File::Definitions.add_field 18, 28, 'trigger', :type => :session_trigger
FitParser::File::Definitions.add_field 18, 29, 'nec_lat', :type => :sint32, :unit => 'semicircles'
FitParser::File::Definitions.add_field 18, 30, 'nec_long', :type => :sint32, :unit => 'semicircles'
FitParser::File::Definitions.add_field 18, 31, 'swc_lat', :type => :sint32, :unit => 'semicircles'
FitParser::File::Definitions.add_field 18, 32, 'swc_long', :type => :sint32, :unit => 'semicircles'
FitParser::File::Definitions.add_field 18, 34, 'normalized_power', :type => :uint16, :unit => 'watts'
FitParser::File::Definitions.add_field 18, 35, 'training_stress_score', :type => :uint16, :scale => 10, :unit => 'tss'
FitParser::File::Definitions.add_field 18, 36, 'intensity_factor', :type => :uint16, :scale => 1000, :unit => 'if'
FitParser::File::Definitions.add_field 18, 37, 'left_right_balance', :type => :left_right_balance_100
FitParser::File::Definitions.add_field 18, 41, 'avg_stroke_count', :type => :uint32, :scale => 10, :unit => 'strokes/lap'
FitParser::File::Definitions.add_field 18, 42, 'avg_stroke_distance', :type => :uint16, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 18, 43, 'swim_stroke', :type => :swim_stroke, :unit => 'swim_stroke', :ref_field_name => 'sport', :ref_field_values => [:swimming]
FitParser::File::Definitions.add_field 18, 44, 'pool_length', :type => :uint16, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 18, 46, 'pool_length_unit', :type => :display_measure, :scale => 1
FitParser::File::Definitions.add_field 18, 47, 'num_active_lengths', :type => :uint16, :unit => 'lengths'
FitParser::File::Definitions.add_field 18, 48, 'total_work', :type => :uint32, :unit => 'J'
FitParser::File::Definitions.add_field 18, 49, 'avg_altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 18, 50, 'max_altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 18, 51, 'gps_accuracy', :type => :uint8, :unit => 'm'
FitParser::File::Definitions.add_field 18, 52, 'avg_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 18, 53, 'avg_pos_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 18, 54, 'avg_neg_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 18, 55, 'max_pos_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 18, 56, 'max_neg_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 18, 57, 'avg_temperature', :type => :sint8, :unit => 'C'
FitParser::File::Definitions.add_field 18, 58, 'max_temperature', :type => :sint8, :unit => 'C'
FitParser::File::Definitions.add_field 18, 59, 'total_moving_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 60, 'avg_pos_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 61, 'avg_neg_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 62, 'max_pos_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 63, 'max_neg_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 64, 'min_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 18, 65, 'time_in_hr_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 66, 'time_in_speed_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 67, 'time_in_cadence_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 68, 'time_in_power_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 69, 'avg_lap_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 18, 70, 'best_lap_index', :type => :uint16
FitParser::File::Definitions.add_field 18, 71, 'min_altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 18, 82, 'player_score', :type => :uint16
FitParser::File::Definitions.add_field 18, 83, 'opponent_score', :type => :uint16
FitParser::File::Definitions.add_field 18, 84, 'opponent_name', :type => :string
FitParser::File::Definitions.add_field 18, 85, 'stroke_count', :type => :uint16, :unit => 'counts'
FitParser::File::Definitions.add_field 18, 86, 'zone_count', :type => :uint16, :unit => 'counts'
FitParser::File::Definitions.add_field 18, 87, 'max_ball_speed', :type => :uint16, :scale => 100, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 88, 'avg_ball_speed', :type => :uint16, :scale => 100, :unit => 'm/s'
FitParser::File::Definitions.add_field 18, 89, 'avg_vertical_oscillation', :type => :uint16, :scale => 10, :unit => 'mm'
FitParser::File::Definitions.add_field 18, 90, 'avg_stance_time_percent', :type => :uint16, :scale => 100, :unit => 'percent'
FitParser::File::Definitions.add_field 18, 91, 'avg_stance_time', :type => :uint16, :scale => 10, :unit => 'ms'
FitParser::File::Definitions.add_field 18, 92, 'avg_fractional_cadence', :type => :uint8, :scale => 128, :unit => 'rpm'
FitParser::File::Definitions.add_field 18, 93, 'max_fractional_cadence', :type => :uint8, :scale => 128, :unit => 'rpm'
FitParser::File::Definitions.add_field 18, 94, 'total_fractional_cycles', :type => :uint8, :scale => 128, :unit => 'cycles'
FitParser::File::Definitions.add_field 18, 95, 'avg_total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 18, 96, 'min_total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 18, 97, 'max_total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 18, 98, 'avg_saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 18, 99, 'min_saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 18, 100, 'max_saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 18, 101, 'avg_left_torque_effectiveness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 18, 102, 'avg_right_torque_effectiveness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 18, 103, 'avg_left_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 18, 104, 'avg_right_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 18, 105, 'avg_combined_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'

FitParser::File::Definitions.add_name 19, 'lap'
FitParser::File::Definitions.add_field 19, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 19, 253, 'timestamp', :type => :date_time, :unit => 's'
FitParser::File::Definitions.add_field 19, 0, 'event', :type => :event
FitParser::File::Definitions.add_field 19, 1, 'event_type', :type => :event_type
FitParser::File::Definitions.add_field 19, 2, 'start_time', :type => :date_time, :scale => 1
FitParser::File::Definitions.add_field 19, 3, 'start_position_lat', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 19, 4, 'start_position_long', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 19, 5, 'end_position_lat', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 19, 6, 'end_position_long', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 19, 7, 'total_elapsed_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 8, 'total_timer_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 9, 'total_distance', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 19, 10, 'total_cycles', :type => :uint32, :unit => 'cycles'
FitParser::File::Definitions.add_field 19, 10, 'total_strides', :type => :uint32, :unit => 'strides', :ref_field_name => 'sport', :ref_field_values => [:running]
FitParser::File::Definitions.add_field 19, 11, 'total_calories', :type => :uint16, :unit => 'kcal'
FitParser::File::Definitions.add_field 19, 12, 'total_fat_calories', :type => :uint16, :unit => 'kcal'
FitParser::File::Definitions.add_field 19, 13, 'avg_speed', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 19, 14, 'max_speed', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 19, 15, 'avg_heart_rate', :type => :uint8, :unit => 'bpm'
FitParser::File::Definitions.add_field 19, 16, 'max_heart_rate', :type => :uint8, :unit => 'bpm'
FitParser::File::Definitions.add_field 19, 17, 'avg_cadence', :type => :uint8, :unit => 'rpm'
FitParser::File::Definitions.add_field 19, 17, 'avg_running_cadence', :type => :uint8, :unit => 'strides/min', :ref_field_name => 'sport', :ref_field_values => [:running]
FitParser::File::Definitions.add_field 19, 18, 'max_cadence', :type => :uint8, :unit => 'rpm'
FitParser::File::Definitions.add_field 19, 18, 'max_running_cadence', :type => :uint8, :unit => 'strides/min', :ref_field_name => 'sport', :ref_field_values => [:running]
FitParser::File::Definitions.add_field 19, 19, 'avg_power', :type => :uint16, :unit => 'watts'
FitParser::File::Definitions.add_field 19, 20, 'max_power', :type => :uint16, :unit => 'watts'
FitParser::File::Definitions.add_field 19, 21, 'total_ascent', :type => :uint16, :unit => 'm'
FitParser::File::Definitions.add_field 19, 22, 'total_descent', :type => :uint16, :unit => 'm'
FitParser::File::Definitions.add_field 19, 23, 'intensity', :type => :intensity
FitParser::File::Definitions.add_field 19, 24, 'lap_trigger', :type => :lap_trigger
FitParser::File::Definitions.add_field 19, 25, 'sport', :type => :sport
FitParser::File::Definitions.add_field 19, 26, 'event_group', :type => :uint8
FitParser::File::Definitions.add_field 19, 32, 'num_lengths', :type => :uint16, :unit => 'lengths'
FitParser::File::Definitions.add_field 19, 33, 'normalized_power', :type => :uint16, :unit => 'watts'
FitParser::File::Definitions.add_field 19, 34, 'left_right_balance', :type => :left_right_balance_100
FitParser::File::Definitions.add_field 19, 35, 'first_length_index', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 19, 37, 'avg_stroke_distance', :type => :uint16, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 19, 38, 'swim_stroke', :type => :swim_stroke
FitParser::File::Definitions.add_field 19, 39, 'sub_sport', :type => :sub_sport, :scale => 1
FitParser::File::Definitions.add_field 19, 40, 'num_active_lengths', :type => :uint16, :unit => 'lengths'
FitParser::File::Definitions.add_field 19, 41, 'total_work', :type => :uint32, :unit => 'J'
FitParser::File::Definitions.add_field 19, 42, 'avg_altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 19, 43, 'max_altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 19, 44, 'gps_accuracy', :type => :uint8, :unit => 'm'
FitParser::File::Definitions.add_field 19, 45, 'avg_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 19, 46, 'avg_pos_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 19, 47, 'avg_neg_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 19, 48, 'max_pos_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 19, 49, 'max_neg_grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 19, 50, 'avg_temperature', :type => :sint8, :unit => 'C'
FitParser::File::Definitions.add_field 19, 51, 'max_temperature', :type => :sint8, :unit => 'C'
FitParser::File::Definitions.add_field 19, 52, 'total_moving_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 53, 'avg_pos_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 19, 54, 'avg_neg_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 19, 55, 'max_pos_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 19, 56, 'max_neg_vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 19, 57, 'time_in_hr_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 58, 'time_in_speed_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 59, 'time_in_cadence_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 60, 'time_in_power_zone', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 19, 61, 'repetition_num', :type => :uint16
FitParser::File::Definitions.add_field 19, 62, 'min_altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 19, 63, 'min_heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 19, 71, 'wkt_step_index', :type => :message_index
FitParser::File::Definitions.add_field 19, 74, 'opponent_score', :type => :uint16
FitParser::File::Definitions.add_field 19, 75, 'stroke_count', :type => :uint16, :unit => 'counts'
FitParser::File::Definitions.add_field 19, 76, 'zone_count', :type => :uint16, :unit => 'counts'
FitParser::File::Definitions.add_field 19, 77, 'avg_vertical_oscillation', :type => :uint16, :scale => 10, :unit => 'mm'
FitParser::File::Definitions.add_field 19, 78, 'avg_stance_time_percent', :type => :uint16, :scale => 100, :unit => 'percent'
FitParser::File::Definitions.add_field 19, 79, 'avg_stance_time', :type => :uint16, :scale => 10, :unit => 'ms'
FitParser::File::Definitions.add_field 19, 80, 'avg_fractional_cadence', :type => :uint8, :scale => 128, :unit => 'rpm'
FitParser::File::Definitions.add_field 19, 81, 'max_fractional_cadence', :type => :uint8, :scale => 128, :unit => 'rpm'
FitParser::File::Definitions.add_field 19, 82, 'total_fractional_cycles', :type => :uint8, :scale => 128, :unit => 'cycles'
FitParser::File::Definitions.add_field 19, 83, 'player_score', :type => :uint16
FitParser::File::Definitions.add_field 19, 84, 'avg_total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 19, 85, 'min_total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 19, 86, 'max_total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 19, 87, 'avg_saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 19, 88, 'min_saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 19, 89, 'max_saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 19, 91, 'avg_left_torque_effectiveness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 19, 92, 'avg_right_torque_effectiveness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 19, 93, 'avg_left_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 19, 94, 'avg_right_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 19, 95, 'avg_combined_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'

FitParser::File::Definitions.add_name 101, 'length'
FitParser::File::Definitions.add_field 101, 254, 'message_index', :type => :message_index, :scale => 1
FitParser::File::Definitions.add_field 101, 253, 'timestamp', :type => :date_time, :scale => 1
FitParser::File::Definitions.add_field 101, 0, 'event', :type => :event
FitParser::File::Definitions.add_field 101, 1, 'event_type', :type => :event_type
FitParser::File::Definitions.add_field 101, 2, 'start_time', :type => :date_time, :scale => 1
FitParser::File::Definitions.add_field 101, 3, 'total_elapsed_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 101, 4, 'total_timer_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 101, 5, 'total_strokes', :type => :uint16, :scale => 1, :unit => 'strokes'
FitParser::File::Definitions.add_field 101, 6, 'avg_speed', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 101, 7, 'swim_stroke', :type => :swim_stroke, :unit => 'swim_stroke'
FitParser::File::Definitions.add_field 101, 9, 'avg_swimming_cadence', :type => :uint8, :unit => 'strokes/min'
FitParser::File::Definitions.add_field 101, 10, 'event_group', :type => :uint8
FitParser::File::Definitions.add_field 101, 11, 'total_calories', :type => :uint16, :unit => 'kcal'
FitParser::File::Definitions.add_field 101, 12, 'length_type', :type => :length_type
FitParser::File::Definitions.add_field 101, 18, 'player_score', :type => :uint16
FitParser::File::Definitions.add_field 101, 19, 'opponent_score', :type => :uint16
FitParser::File::Definitions.add_field 101, 20, 'stroke_count', :type => :uint16, :unit => 'counts'
FitParser::File::Definitions.add_field 101, 21, 'zone_count', :type => :uint16, :unit => 'counts'

FitParser::File::Definitions.add_name 20, 'record'
FitParser::File::Definitions.add_field 20, 253, 'timestamp', :type => :date_time, :scale => 1, :unit => 's'
FitParser::File::Definitions.add_field 20, 0, 'position_lat', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 20, 1, 'position_long', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 20, 2, 'altitude', :type => :uint16, :scale => 5, :offset => 500, :unit => 'm'
FitParser::File::Definitions.add_field 20, 3, 'heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 20, 4, 'cadence', :type => :uint8, :scale => 1, :unit => 'rpm'
FitParser::File::Definitions.add_field 20, 5, 'distance', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 20, 6, 'speed', :type => :uint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 20, 7, 'power', :type => :uint16, :unit => 'watts'
FitParser::File::Definitions.add_field 20, 8, 'compressed_speed_distance', :type => :byte, :unit => 'm/s,m'
FitParser::File::Definitions.add_field 20, 9, 'grade', :type => :sint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 20, 10, 'resistance', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 20, 11, 'time_from_course', :type => :sint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 20, 12, 'cycle_length', :type => :uint8, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 20, 13, 'temperature', :type => :sint8, :unit => 'C'
FitParser::File::Definitions.add_field 20, 17, 'speed_1s', :type => :uint8, :scale => 16, :unit => 'm/s'
FitParser::File::Definitions.add_field 20, 18, 'cycles', :type => :uint8, :unit => 'cycles'
FitParser::File::Definitions.add_field 20, 19, 'total_cycles', :type => :uint32, :unit => 'cycles'
FitParser::File::Definitions.add_field 20, 28, 'compressed_accumulated_power', :type => :uint16, :unit => 'watts'
FitParser::File::Definitions.add_field 20, 29, 'accumulated_power', :type => :uint32, :unit => 'watts'
FitParser::File::Definitions.add_field 20, 30, 'left_right_balance', :type => :left_right_balance
FitParser::File::Definitions.add_field 20, 31, 'gps_accuracy', :type => :uint8, :unit => 'm'
FitParser::File::Definitions.add_field 20, 32, 'vertical_speed', :type => :sint16, :scale => 1000, :unit => 'm/s'
FitParser::File::Definitions.add_field 20, 33, 'calories', :type => :uint16, :scale => 1, :unit => 'kcal'
FitParser::File::Definitions.add_field 20, 39, 'vertical_oscillation', :type => :uint16, :scale => 10, :unit => 'mm'
FitParser::File::Definitions.add_field 20, 40, 'stance_time_percent', :type => :uint16, :scale => 100, :unit => 'percent'
FitParser::File::Definitions.add_field 20, 41, 'stance_time', :type => :uint16, :scale => 10, :unit => 'ms'
FitParser::File::Definitions.add_field 20, 42, 'activity_type', :type => :activity_type
FitParser::File::Definitions.add_field 20, 43, 'left_torque_effectiveness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 20, 44, 'right_torque_effectiveness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 20, 45, 'left_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 20, 46, 'right_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 20, 47, 'combined_pedal_smoothness', :type => :uint8, :scale => 2, :unit => 'percent'
FitParser::File::Definitions.add_field 20, 48, 'time128', :type => :uint8, :scale => 128, :unit => 's'
FitParser::File::Definitions.add_field 20, 49, 'stroke_type', :type => :stroke_type
FitParser::File::Definitions.add_field 20, 50, 'zone', :type => :uint8
FitParser::File::Definitions.add_field 20, 51, 'ball_speed', :type => :uint16, :scale => 100, :unit => 'm/s'
FitParser::File::Definitions.add_field 20, 52, 'cadence256', :type => :uint16, :scale => 256, :unit => 'rpm'
FitParser::File::Definitions.add_field 20, 53, 'fractional_cadence', :type => :uint8, :scale => 128, :unit => 'rpm'
FitParser::File::Definitions.add_field 20, 54, 'total_hemoglobin_conc', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 20, 55, 'total_hemoglobin_conc_min', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 20, 56, 'total_hemoglobin_conc_max', :type => :uint16, :scale => 100, :unit => 'g/dL'
FitParser::File::Definitions.add_field 20, 57, 'saturated_hemoglobin_percent', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 20, 58, 'saturated_hemoglobin_percent_min', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 20, 59, 'saturated_hemoglobin_percent_max', :type => :uint16, :scale => 10, :unit => '%'
FitParser::File::Definitions.add_field 20, 62, 'device_index', :type => :device_index

FitParser::File::Definitions.add_name 21, 'event'
FitParser::File::Definitions.add_field 21, 253, 'timestamp', :type => :date_time, :unit => 's'
FitParser::File::Definitions.add_field 21, 0, 'event', :type => :event
FitParser::File::Definitions.add_field 21, 1, 'event_type', :type => :event_type
FitParser::File::Definitions.add_field 21, 2, 'data16', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 21, 3, 'data', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 21, 3, 'timer_trigger', :type => :timer_trigger, :scale => 1, :ref_field_name => 'event', :ref_field_values => [:timer]
FitParser::File::Definitions.add_field 21, 3, 'course_point_index', :type => :message_index, :scale => 1, :ref_field_name => 'event', :ref_field_values => [:course_point]
FitParser::File::Definitions.add_field 21, 3, 'battery_level', :type => :uint16, :scale => 1000, :unit => 'V', :ref_field_name => 'event', :ref_field_values => [:battery]
FitParser::File::Definitions.add_field 21, 3, 'virtual_partner_speed', :type => :uint16, :scale => 1000, :unit => 'm/s', :ref_field_name => 'event', :ref_field_values => [:virtual_partner_pace]
FitParser::File::Definitions.add_field 21, 3, 'hr_high_alert', :type => :uint8, :scale => 1, :unit => 'bpm', :ref_field_name => 'event', :ref_field_values => [:hr_high_alert]
FitParser::File::Definitions.add_field 21, 3, 'hr_low_alert', :type => :uint8, :scale => 1, :unit => 'bpm', :ref_field_name => 'event', :ref_field_values => [:hr_low_alert]
FitParser::File::Definitions.add_field 21, 3, 'speed_high_alert', :type => :uint16, :scale => 1000, :unit => 'm/s', :ref_field_name => 'event', :ref_field_values => [:speed_high_alert]
FitParser::File::Definitions.add_field 21, 3, 'speed_low_alert', :type => :uint16, :scale => 1000, :unit => 'm/s', :ref_field_name => 'event', :ref_field_values => [:speed_low_alert]
FitParser::File::Definitions.add_field 21, 3, 'cad_high_alert', :type => :uint16, :scale => 1, :unit => 'rpm', :ref_field_name => 'event', :ref_field_values => [:cad_high_alert]
FitParser::File::Definitions.add_field 21, 3, 'cad_low_alert', :type => :uint16, :scale => 1, :unit => 'rpm', :ref_field_name => 'event', :ref_field_values => [:cad_low_alert]
FitParser::File::Definitions.add_field 21, 3, 'power_high_alert', :type => :uint16, :scale => 1, :unit => 'watts', :ref_field_name => 'event', :ref_field_values => [:power_high_alert]
FitParser::File::Definitions.add_field 21, 3, 'power_low_alert', :type => :uint16, :scale => 1, :unit => 'watts', :ref_field_name => 'event', :ref_field_values => [:power_low_alert]
FitParser::File::Definitions.add_field 21, 3, 'time_duration_alert', :type => :uint32, :scale => 1000, :unit => 's', :ref_field_name => 'event', :ref_field_values => [:time_duration_alert]
FitParser::File::Definitions.add_field 21, 3, 'distance_duration_alert', :type => :uint32, :scale => 100, :unit => 'm', :ref_field_name => 'event', :ref_field_values => [:distance_duration_alert]
FitParser::File::Definitions.add_field 21, 3, 'calorie_duration_alert', :type => :uint32, :scale => 1, :unit => 'calories', :ref_field_name => 'event', :ref_field_values => [:calorie_duration_alert]
FitParser::File::Definitions.add_field 21, 3, 'fitness_equipment_state', :type => :fitness_equipment_state, :scale => 1, :ref_field_name => 'event', :ref_field_values => [:fitness_equipment]
FitParser::File::Definitions.add_field 21, 3, 'sport_point', :type => :uint32, :scale => 1, :ref_field_name => 'event', :ref_field_values => [:sport_point]
FitParser::File::Definitions.add_field 21, 3, 'gear_change_data', :type => :uint32, :scale => 1, :ref_field_name => 'event', :ref_field_values => [:front_gear_change, :rear_gear_change]
FitParser::File::Definitions.add_field 21, 4, 'event_group', :type => :uint8
FitParser::File::Definitions.add_field 21, 7, 'score', :type => :uint16
FitParser::File::Definitions.add_field 21, 8, 'opponent_score', :type => :uint16
FitParser::File::Definitions.add_field 21, 9, 'front_gear_num', :type => :uint8z
FitParser::File::Definitions.add_field 21, 10, 'front_gear', :type => :uint8z
FitParser::File::Definitions.add_field 21, 11, 'rear_gear_num', :type => :uint8z
FitParser::File::Definitions.add_field 21, 12, 'rear_gear', :type => :uint8z

FitParser::File::Definitions.add_name 23, 'device_info'
FitParser::File::Definitions.add_field 23, 253, 'timestamp', :type => :date_time, :scale => 1, :unit => 's'
FitParser::File::Definitions.add_field 23, 0, 'device_index', :type => :device_index, :scale => 1
FitParser::File::Definitions.add_field 23, 1, 'device_type', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 23, 1, 'antplus_device_type', :type => :antplus_device_type, :ref_field_name => 'source_type', :ref_field_values => [:antplus]
FitParser::File::Definitions.add_field 23, 1, 'ant_device_type', :type => :uint8, :ref_field_name => 'source_type', :ref_field_values => [:ant]
FitParser::File::Definitions.add_field 23, 2, 'manufacturer', :type => :manufacturer, :scale => 1
FitParser::File::Definitions.add_field 23, 3, 'serial_number', :type => :uint32z, :scale => 1
FitParser::File::Definitions.add_field 23, 4, 'product', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 23, 5, 'software_version', :type => :uint16, :scale => 100
FitParser::File::Definitions.add_field 23, 6, 'hardware_version', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 23, 7, 'cum_operating_time', :type => :uint32, :scale => 1, :unit => 's'
FitParser::File::Definitions.add_field 23, 10, 'battery_voltage', :type => :uint16, :scale => 256, :unit => 'V'
FitParser::File::Definitions.add_field 23, 11, 'battery_status', :type => :battery_status
FitParser::File::Definitions.add_field 23, 18, 'sensor_position', :type => :body_location
FitParser::File::Definitions.add_field 23, 19, 'descriptor', :type => :string
FitParser::File::Definitions.add_field 23, 20, 'ant_transmission_type', :type => :uint8z
FitParser::File::Definitions.add_field 23, 21, 'ant_device_number', :type => :uint16z
FitParser::File::Definitions.add_field 23, 22, 'ant_network', :type => :ant_network
FitParser::File::Definitions.add_field 23, 25, 'source_type', :type => :source_type

FitParser::File::Definitions.add_name 72, 'training_file'
FitParser::File::Definitions.add_field 72, 253, 'timestamp', :type => :date_time
FitParser::File::Definitions.add_field 72, 0, 'type', :type => :file
FitParser::File::Definitions.add_field 72, 1, 'manufacturer', :type => :manufacturer
FitParser::File::Definitions.add_field 72, 2, 'product', :type => :uint16
FitParser::File::Definitions.add_field 72, 2, 'garmin_product', :type => :garmin_product, :ref_field_name => 'manufacturer', :ref_field_values => [:garmin, :dynastream, :dynastream_oem]
FitParser::File::Definitions.add_field 72, 3, 'serial_number', :type => :uint32z
FitParser::File::Definitions.add_field 72, 4, 'time_created', :type => :date_time

FitParser::File::Definitions.add_name 78, 'hrv'
FitParser::File::Definitions.add_field 78, 0, 'time', :type => :uint16, :scale => 1000, :unit => 's'

FitParser::File::Definitions.add_name 31, 'course'
FitParser::File::Definitions.add_field 31, 4, 'sport', :type => :sport
FitParser::File::Definitions.add_field 31, 5, 'name', :type => :string
FitParser::File::Definitions.add_field 31, 6, 'capabilities', :type => :course_capabilities

FitParser::File::Definitions.add_name 32, 'course_point'
FitParser::File::Definitions.add_field 32, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 32, 1, 'timestamp', :type => :date_time, :scale => 1
FitParser::File::Definitions.add_field 32, 2, 'position_lat', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 32, 3, 'position_long', :type => :sint32, :scale => 1, :unit => 'semicircles'
FitParser::File::Definitions.add_field 32, 4, 'distance', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 32, 5, 'type', :type => :course_point, :scale => 1
FitParser::File::Definitions.add_field 32, 6, 'name', :type => :string

FitParser::File::Definitions.add_name 26, 'workout'
FitParser::File::Definitions.add_field 26, 4, 'sport', :type => :sport, :scale => 1
FitParser::File::Definitions.add_field 26, 5, 'capabilities', :type => :workout_capabilities
FitParser::File::Definitions.add_field 26, 6, 'num_valid_steps', :type => :uint16, :scale => 1
FitParser::File::Definitions.add_field 26, 8, 'wkt_name', :type => :string, :scale => 1

FitParser::File::Definitions.add_name 27, 'workout_step'
FitParser::File::Definitions.add_field 27, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 27, 0, 'wkt_step_name', :type => :string, :scale => 1
FitParser::File::Definitions.add_field 27, 1, 'duration_type', :type => :wkt_step_duration, :scale => 1
FitParser::File::Definitions.add_field 27, 2, 'duration_value', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 27, 2, 'duration_time', :type => :uint32, :scale => 1000, :unit => 's', :ref_field_name => 'duration_type', :ref_field_values => [:time, :repetition_time]
FitParser::File::Definitions.add_field 27, 2, 'duration_distance', :type => :uint32, :scale => 100, :unit => 'm', :ref_field_name => 'duration_type', :ref_field_values => [:distance]
FitParser::File::Definitions.add_field 27, 2, 'duration_hr', :type => :workout_hr, :scale => 1, :unit => '% or bpm', :ref_field_name => 'duration_type', :ref_field_values => [:hr_less_than, :hr_greater_than]
FitParser::File::Definitions.add_field 27, 2, 'duration_calories', :type => :uint32, :scale => 1, :unit => 'calories', :ref_field_name => 'duration_type', :ref_field_values => [:calories]
FitParser::File::Definitions.add_field 27, 2, 'duration_step', :type => :uint32, :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_steps_cmplt, :repeat_until_time, :repeat_until_distance, :repeat_until_calories, :repeat_until_hr_less_than, :repeat_until_hr_greater_than, :repeat_until_power_less_than,:repeat_until_power_greater_than]
FitParser::File::Definitions.add_field 27, 2, 'duration_power', :type => :workout_power, :scale => 1, :unit => '% or watts', :ref_field_name => 'duration_type', :ref_field_values => [:power_less_than, :power_greater_than]
FitParser::File::Definitions.add_field 27, 3, 'target_type', :type => :wkt_step_target, :scale => 1
FitParser::File::Definitions.add_field 27, 4, 'target_value', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 27, 4, 'target_hr_zone', :type => :uint32, :ref_field_name => 'target_type', :ref_field_values => [:heart_rate]
FitParser::File::Definitions.add_field 27, 4, 'target_power_zone', :type => :uint32, :ref_field_name => 'target_type', :ref_field_values => [:power]
FitParser::File::Definitions.add_field 27, 4, 'repeat_steps', :type => :uint32, :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_steps_cmplt]
FitParser::File::Definitions.add_field 27, 4, 'repeat_time', :type => :uint32, :scale => 1000, :unit => 's', :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_time]
FitParser::File::Definitions.add_field 27, 4, 'repeat_distance', :type => :uint32, :scale => 100, :unit => 'm', :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_distance]
FitParser::File::Definitions.add_field 27, 4, 'repeat_calories', :type => :uint32, :scale => 1, :unit => 'calories', :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_calories]
FitParser::File::Definitions.add_field 27, 4, 'repeat_hr', :type => :workout_hr, :scale => 1, :unit => '% or bpm', :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_hr_less_than, :repeat_until_hr_greater_than]
FitParser::File::Definitions.add_field 27, 4, 'repeat_power', :type => :workout_power, :scale => 1, :unit => '% or watts', :ref_field_name => 'duration_type', :ref_field_values => [:repeat_until_power_less_than, :repeat_until_power_greater_than]
FitParser::File::Definitions.add_field 27, 5, 'custom_target_value_low', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 27, 5, 'custom_target_speed_low', :type => :uint32, :scale => 1000, :unit => 'm/s', :ref_field_name => 'target_type', :ref_field_values => [:speed]
FitParser::File::Definitions.add_field 27, 5, 'custom_target_heart_rate_low', :type => :workout_hr, :scale => 1, :unit => '% or bpm', :ref_field_name => 'target_type', :ref_field_values => [:heart_rate]
FitParser::File::Definitions.add_field 27, 5, 'custom_target_cadence_low', :type => :uint32, :scale => 1, :unit => 'rpm', :ref_field_name => 'target_type', :ref_field_values => [:cadence]
FitParser::File::Definitions.add_field 27, 5, 'custom_target_power_low', :type => :workout_power, :scale => 1, :unit => '% or watts', :ref_field_name => 'target_type', :ref_field_values => [:power]
FitParser::File::Definitions.add_field 27, 6, 'custom_target_value_high', :type => :uint32, :scale => 1
FitParser::File::Definitions.add_field 27, 6, 'custom_target_speed_high', :type => :uint32, :scale => 1000, :unit => 'm/s', :ref_field_name => 'target_type', :ref_field_values => [:speed]
FitParser::File::Definitions.add_field 27, 6, 'custom_target_heart_rate_high', :type => :workout_hr, :scale => 1, :unit => '% or bpm', :ref_field_name => 'target_type', :ref_field_values => [:heart_rate]
FitParser::File::Definitions.add_field 27, 6, 'custom_target_cadence_high', :type => :uint32, :scale => 1, :unit => 'rpm', :ref_field_name => 'target_type', :ref_field_values => [:cadence]
FitParser::File::Definitions.add_field 27, 6, 'custom_target_power_high', :type => :workout_power, :scale => 1, :unit => '% or watts', :ref_field_name => 'target_type', :ref_field_values => [:power]
FitParser::File::Definitions.add_field 27, 7, 'intensity', :type => :intensity, :scale => 1

FitParser::File::Definitions.add_name 28, 'schedule'
FitParser::File::Definitions.add_field 28, 0, 'manufacturer', :type => :manufacturer
FitParser::File::Definitions.add_field 28, 1, 'product', :type => :uint16
FitParser::File::Definitions.add_field 28, 1, 'garmin_product', :type => :garmin_product, :ref_field_name => 'manufacturer', :ref_field_values => [:garmin, :dynastream, :dynastream_oem]
FitParser::File::Definitions.add_field 28, 2, 'serial_number', :type => :uint32z
FitParser::File::Definitions.add_field 28, 3, 'time_created', :type => :date_time
FitParser::File::Definitions.add_field 28, 4, 'completed', :type => :bool, :scale => 1
FitParser::File::Definitions.add_field 28, 5, 'type', :type => :schedule, :scale => 1
FitParser::File::Definitions.add_field 28, 6, 'scheduled_time', :type => :local_date_time

FitParser::File::Definitions.add_name 33, 'totals'
FitParser::File::Definitions.add_field 33, 254, 'message_index', :type => :message_index
FitParser::File::Definitions.add_field 33, 253, 'timestamp', :type => :date_time, :unit => 's'
FitParser::File::Definitions.add_field 33, 0, 'timer_time', :type => :uint32, :unit => 's'
FitParser::File::Definitions.add_field 33, 1, 'distance', :type => :uint32, :unit => 'm'
FitParser::File::Definitions.add_field 33, 2, 'calories', :type => :uint32, :unit => 'kcal'
FitParser::File::Definitions.add_field 33, 3, 'sport', :type => :sport
FitParser::File::Definitions.add_field 33, 4, 'elapsed_time', :type => :uint32, :unit => 's'
FitParser::File::Definitions.add_field 33, 5, 'sessions', :type => :uint16
FitParser::File::Definitions.add_field 33, 6, 'active_time', :type => :uint32, :unit => 's'

FitParser::File::Definitions.add_name 30, 'weight_scale'
FitParser::File::Definitions.add_field 30, 253, 'timestamp', :type => :date_time, :scale => 1, :unit => 's'
FitParser::File::Definitions.add_field 30, 0, 'weight', :type => :weight, :scale => 100, :unit => 'kg'
FitParser::File::Definitions.add_field 30, 1, 'percent_fat', :type => :uint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 30, 2, 'percent_hydration', :type => :uint16, :scale => 100, :unit => '%'
FitParser::File::Definitions.add_field 30, 3, 'visceral_fat_mass', :type => :uint16, :scale => 100, :unit => 'kg'
FitParser::File::Definitions.add_field 30, 4, 'bone_mass', :type => :uint16, :scale => 100, :unit => 'kg'
FitParser::File::Definitions.add_field 30, 5, 'muscle_mass', :type => :uint16, :scale => 100, :unit => 'kg'
FitParser::File::Definitions.add_field 30, 7, 'basal_met', :type => :uint16, :scale => 4, :unit => 'kcal/day'
FitParser::File::Definitions.add_field 30, 8, 'physique_rating', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 30, 9, 'active_met', :type => :uint16, :scale => 4, :unit => 'kcal/day'
FitParser::File::Definitions.add_field 30, 10, 'metabolic_age', :type => :uint8, :scale => 1, :unit => 'years'
FitParser::File::Definitions.add_field 30, 11, 'visceral_fat_rating', :type => :uint8, :scale => 1
FitParser::File::Definitions.add_field 30, 12, 'user_profile_index', :type => :message_index

FitParser::File::Definitions.add_name 51, 'blood_pressure'
FitParser::File::Definitions.add_field 51, 253, 'timestamp', :type => :date_time, :scale => 1, :unit => 's'
FitParser::File::Definitions.add_field 51, 0, 'systolic_pressure', :type => :uint16, :scale => 1, :unit => 'mmHg'
FitParser::File::Definitions.add_field 51, 1, 'diastolic_pressure', :type => :uint16, :scale => 1, :unit => 'mmHg'
FitParser::File::Definitions.add_field 51, 2, 'mean_arterial_pressure', :type => :uint16, :scale => 1, :unit => 'mmHg'
FitParser::File::Definitions.add_field 51, 3, 'map_3_sample_mean', :type => :uint16, :scale => 1, :unit => 'mmHg'
FitParser::File::Definitions.add_field 51, 4, 'map_morning_values', :type => :uint16, :scale => 1, :unit => 'mmHg'
FitParser::File::Definitions.add_field 51, 5, 'map_evening_values', :type => :uint16, :scale => 1, :unit => 'mmHg'
FitParser::File::Definitions.add_field 51, 6, 'heart_rate', :type => :uint8, :scale => 1, :unit => 'bpm'
FitParser::File::Definitions.add_field 51, 7, 'heart_rate_type', :type => :hr_type
FitParser::File::Definitions.add_field 51, 8, 'status', :type => :bp_status
FitParser::File::Definitions.add_field 51, 9, 'user_profile_index', :type => :message_index

FitParser::File::Definitions.add_name 103, 'monitoring_info'
FitParser::File::Definitions.add_field 103, 253, 'timestamp', :type => :date_time
FitParser::File::Definitions.add_field 103, 0, 'local_timestamp', :type => :local_date_time
FitParser::File::Definitions.add_field 103, 1, 'activity_type', :type => :activity_type
FitParser::File::Definitions.add_field 103, 3, 'cycles_to_distance', :type => :uint16, :scale => 5000, :unit => 'm/cycle'
FitParser::File::Definitions.add_field 103, 4, 'cycles_to_calories', :type => :uint16, :scale => 5000, :unit => 'kcal/cycle'
FitParser::File::Definitions.add_field 103, 5, 'resting_metabolic_rate', :type => :uint16, :unit => 'kcal / day'

FitParser::File::Definitions.add_name 55, 'monitoring'
FitParser::File::Definitions.add_field 55, 253, 'timestamp', :type => :date_time, :unit => 's'
FitParser::File::Definitions.add_field 55, 0, 'device_index', :type => :device_index
FitParser::File::Definitions.add_field 55, 1, 'calories', :type => :uint16, :unit => 'kcal'
FitParser::File::Definitions.add_field 55, 2, 'distance', :type => :uint32, :scale => 100, :unit => 'm'
FitParser::File::Definitions.add_field 55, 3, 'cycles', :type => :uint32, :scale => 2, :unit => 'cycles'
FitParser::File::Definitions.add_field 55, 3, 'steps', :type => :uint32, :scale => 1, :unit => 'steps', :ref_field_name => 'activity_type', :ref_field_values => [:walking, :running]
FitParser::File::Definitions.add_field 55, 3, 'strokes', :type => :uint32, :scale => 2, :unit => 'strokes', :ref_field_name => 'activity_type', :ref_field_values => [:cycling, :swimming]
FitParser::File::Definitions.add_field 55, 4, 'active_time', :type => :uint32, :scale => 1000, :unit => 's'
FitParser::File::Definitions.add_field 55, 5, 'activity_type', :type => :activity_type
FitParser::File::Definitions.add_field 55, 6, 'activity_subtype', :type => :activity_subtype
FitParser::File::Definitions.add_field 55, 7, 'activity_level', :type => :activity_level
FitParser::File::Definitions.add_field 55, 8, 'distance_16', :type => :uint16, :unit => '100 * m'
FitParser::File::Definitions.add_field 55, 9, 'cycles_16', :type => :uint16, :unit => '(steps)'
FitParser::File::Definitions.add_field 55, 10, 'active_time_16', :type => :uint16, :unit => 's'
FitParser::File::Definitions.add_field 55, 11, 'local_timestamp', :type => :local_date_time
FitParser::File::Definitions.add_field 55, 12, 'temperature', :type => :sint16, :scale => 100, :unit => 'C'
FitParser::File::Definitions.add_field 55, 14, 'temperature_min', :type => :sint16, :scale => 100, :unit => 'C'
FitParser::File::Definitions.add_field 55, 15, 'temperature_max', :type => :sint16, :scale => 100, :unit => 'C'
FitParser::File::Definitions.add_field 55, 16, 'activity_time', :type => :uint16, :unit => 'minutes'
FitParser::File::Definitions.add_field 55, 19, 'active_calories', :type => :uint16, :unit => 'kcal'
FitParser::File::Definitions.add_field 55, 24, 'current_activity_type_intensity', :type => :byte
FitParser::File::Definitions.add_field 55, 25, 'timestamp_min_8', :type => :uint8, :unit => 'min'
FitParser::File::Definitions.add_field 55, 26, 'timestamp_16', :type => :uint16, :unit => 's'
FitParser::File::Definitions.add_field 55, 27, 'heart_rate', :type => :uint8, :unit => 'bpm'
FitParser::File::Definitions.add_field 55, 28, 'intensity', :type => :uint8, :scale => 10
FitParser::File::Definitions.add_field 55, 29, 'duration_min', :type => :uint16, :unit => 'min'
FitParser::File::Definitions.add_field 55, 30, 'duration', :type => :uint32, :unit => 's'

FitParser::File::Definitions.add_name 145, 'memo_glob'
FitParser::File::Definitions.add_field 145, 250, 'part_index', :type => :uint32
FitParser::File::Definitions.add_field 145, 0, 'memo', :type => :byte
FitParser::File::Definitions.add_field 145, 1, 'message_number', :type => :uint16
FitParser::File::Definitions.add_field 145, 2, 'message_index', :type => :message_index
