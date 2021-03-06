require "rails_matching/version"

module RailsMatching
  #
  # Sets common parameters between diferent methods of matchs
  # By default excludes common table fields as id, created at, updated at
  # Sets id of an object as default response
  # You can set map one param to another as:
  # [["model1_attr1", "model2_attr1"], ["model1_attr2", "model2_attr4"]]
  # [["band", "favorite_band"], ["age", "years"]]
  # This is gonna be nice with one model has different attrinbute name from another model
  #
  def self.parametrize(_key = "id", _exclude_attrs = [], _map_params = [])
    exclude_attrs += %w[ id created_at updated_at ] if _exclude_attrs.count == 0  
  end

  def self.validates_model(model)
    raise "Error, first param must be an object" unless model.first.is_a? Object
    raise "Error, first params must have at least one attribute" if model.first.attributes.count <= 0
    raise "Error, first param must have and id" if model.first.id.nil?  
  end

  #
  # Matchs one model instance against all model instances
  # by default it excludes common table fields 
  # as id, created at, updated at
  # runs one model against another twice
  # 
  def self.against_itself(model, key = "id", exclude_attrs = [])
    
    validates_model(model)
    
    exclude_attrs += %w[ id created_at updated_at ]
    model_attrs = model.new.attributes.keys - exclude_attrs

    # For each instance of a model
    # Gets its atributes
    # See if it matches with the same attribute of others instances

    # Returns model key and it's percentage of match against another model like
    # [ "a1", "a2", 99.9 ]
    # [ a1, a3, 99.9 ]
    # [ a1, a4, 45.9 ]
    # [ a3, a1, 99.9 ]

    result = model.all.map{ |a|
      mathed = model.all.map{ |b|
        # do not run againts same instance
        if a.id != b.id
          matched_attrs = model_attrs.map{ |k|
            a[k] == b[k] ? true : false
          }
          count = matched_attrs.count{ |e| e == true }
          percentage = ( count * 100 ) / model_attrs.count
          [ a[key], b[key], percentage ]
        end
      }
      # return without nil values
      mathed.compact
    }

    result
  end

  #
  # Matchs one model against itself
  # by default it excludes common table fields 
  # as id, created at, updated at
  # does not run one model against another twice
  #
  # def against_itself_compact(model, key = "id", exclude_attrs = []) 
  # end

  #
  # Matchs one model against another model
  # by default it excludes common table fields 
  # as id, created at, updated at
  # does not run one model against another twice
  # required matched attributes must return true do be in the response
  # def model_against_model(model1, model2,  required_match_fields = [], key = "id", exclude_attrs = [])
  # end

  #
  # Matchs one instance against all instances from a model
  # by default it excludes common table fields 
  # as id, created at, updated at
  def self.instance_against_all(instance, model, _required_match_fields = [], key = "id", exclude_attrs = [])
  	
  	validates_model(model)
  	
  	exclude_attrs += %w[ id created_at updated_at ]
		model_attrs = model.new.attributes.keys - exclude_attrs

    # For each instance of a model
    # Gets its atributes
    # See if it matches with the same attribute instance

    # Returns instances keys and it's percentage of match
    # [ a1, a3, 99.9 ]
    # [ a1, a4, 45.9 ]
    # [ a3, a1, 99.9 ]

		result = model.all.map{ |a|
	      # do not run againts same instance
	      if a.id != instance.id
	        matched_attrs = model_attrs.map{ |attribute|
	          a[attribute] == instance[attribute] ? true : false
	        }
	        count = matched_attrs.count{ |attribute| attribute == true }
	        percentage = ( count * 100 ) / model_attrs.count
	        [ instance[key], a[key], percentage ]
	      end
	    }

		result.compact

  end

  #
  # Matchs one model against another model
  # by default it excludes common table fields 
  # as id, created at, updated at
  # does not run one model against another twice
  # required matched attributes must return true do be in the response
  #
  # def instance_against_instance(instance1, instance2, required_match_fields = [], key = "id", exclude_attrs = [])
  # end

  #
  # Matchs one model against another model
  # by default it excludes common table fields 
  # as id, created at, updated at
  # does not run one model against another twice
  # required matched attributes must return true do be in the response
  #
  # def instance_against_instance_with_relations(instance1, instance2, relations = [], required_match_fields = [], key = "id", exclude_attrs = [])
  # end

end
