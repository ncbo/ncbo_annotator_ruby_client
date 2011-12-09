require "test/unit"
require "ncbo_annotator"

class TestAnnotator < Test::Unit::TestCase
  APIKEY = ""

  def test_apikey
    raise ArgumentError, "You must provide an API Key" if APIKEY.nil? || APIKEY.empty?
  end

  def test_instantiation
    annotator = NCBO::Annotator.new(:apikey => APIKEY)
    assert annotator.kind_of?(NCBO::Annotator)
    
    melanoma = annotator.annotate("melanoma")
    cancer = annotator.annotate("cancer")
    assert melanoma.annotations != cancer.annotations
  end
  
  def test_direct_usage
    result = NCBO::Annotator.annotate("melanoma", :apikey => APIKEY)
    assert !result.annotations.nil? && result.annotations.length > 0
  end
  
  def test_alternative_location
    alt_location = "http://stagerest.bioontology.org/obs/annotator"
    annotator = NCBO::Annotator.new(:apikey => APIKEY, :annotator_location => alt_location)
    assert annotator.options[:annotator_location] == alt_location
  end
  
  def test_ontologies_to_keep_in_results
    annotator = NCBO::Annotator.new(:apikey => APIKEY, :ontologiesToKeepInResult => 1032)
    single_ontology = annotator.annotate("melanoma")
    assert single_ontology.ontologies.length == 1 && single_ontology.ontologies[0][:virtualOntologyId] == 1032
    
    multiple_ontologies = annotator.annotate("cancer", :ontologiesToKeepInResult => [1032, 1089])
    assert multiple_ontologies.ontologies.length == 2
    assert multiple_ontologies.ontologies[0][:virtualOntologyId] == 1032 || multiple_ontologies.ontologies[0][:virtualOntologyId] == 1089
    assert multiple_ontologies.ontologies[1][:virtualOntologyId] == 1032 || multiple_ontologies.ontologies[1][:virtualOntologyId] == 1089
  end
  
  def test_max_level
    no_max = NCBO::Annotator.annotate("melanoma", :apikey => APIKEY)
    max = NCBO::Annotator.annotate("melanoma", :apikey => APIKEY, :levelMax => 1)
    assert no_max.annotations != max.annotations
  end
  
  def test_ontologies(ontologies = nil)
    ontologies = NCBO::Annotator.ontologies(:apikey => APIKEY) if ontologies.nil?
    assert ontologies.kind_of?(Array)
    assert ontologies.length > 1
    
    ncit_exists = false
    ontologies.each do |ontology|
      if ontology[:virtualOntologyId] == (1032)
        ncit_exists = true
        break
      end
    end
    assert ncit_exists
  end
  
  def test_ontologies_instantiation
    annotator = NCBO::Annotator.new(:apikey => APIKEY)
    annotator.annotate("melanoma")
    test_ontologies(annotator.ontologies)
    
    annotator.annotate("cancer")
    test_ontologies(annotator.ontologies)
  end
  
  def test_semantic_types
    semantic_types = NCBO::Annotator.semantic_types(:apikey => APIKEY)
    assert semantic_types.kind_of?(Array) && semantic_types.length > 1
  end

end