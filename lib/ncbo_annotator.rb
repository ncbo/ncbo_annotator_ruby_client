require 'net/http'
require 'xml'
require 'uri'
require 'open-uri'
require 'ncbo_annotator/parser'

module NCBO
  class Annotator

    def initialize(args = {})
      @options = {}
  
      @options[:annotator_location] = "http://rest.bioontology.org/obs"
      @options[:filterNumber] = true
      @options[:isStopWordsCaseSensitive] = false
      @options[:isVirtualOntologyId] = true
      @options[:levelMax] = 0
      @options[:longestOnly] = false
      @options[:ontologiesToExpand] = []
      @options[:ontologiesToKeepInResult] = []
      @options[:mappingTypes] = []
      @options[:minTermSize] = 3
      @options[:scored] = true
      @options[:semanticTypes] = []
      @options[:stopWords] = []
      @options[:wholeWordOnly] = true
      @options[:withDefaultStopWords] = false
      @options[:withSynonyms] = true
    
      @options.merge!(args)
      
      @ontologies = nil
    
      raise ArgumentError, ":apikey is required, you can obtain one at http://bioportal.bioontology.org/accounts/new" if @options[:apikey].nil?
    end
  
    def self.annotate(text, options = {})
      options[:textToAnnotate] = text
      new(options).annotate
    end
  
    def annotate(text = nil, options = {})
      @options[:textToAnnotate] = text unless text.nil?
      @options.merge!(options) unless options.empty?
      
      raise ArgumentError, ":textToAnnotate must be included" if @options[:textToAnnotate].nil?
      
      result_xml = annotate_post
      Parser::Annotator.parse_results(result_xml)
    end
    
    def self.ontologies(options)
      new(options).ontologies
    end
    
    def ontologies
      if @ontologies.nil?
        ontologies_xml = open("#{@options[:annotator_location]}/ontologies?apikey=#{@options[:apikey]}").read
        @ontologies = Parser::Annotator.parse_included_ontologies(ontologies_xml)
      else
        @ontologies
      end
    end
    
    def self.semantic_types(options)
      new(options).semantic_types
    end
    
    def semantic_types
      if @semantic_types.nil?
        semantic_types_xml = open("#{@options[:annotator_location]}/semanticTypes?apikey=#{@options[:apikey]}").read
        @semantic_types = Parser::Annotator.parse_semantic_types(semantic_types_xml)
      else
        @semantic_types
      end
    end
    
    def options
      @options
    end

    private

    def annotate_post
      url = @options[:annotator_location] + "/annotator"
      options = @options.clone
      options.each do |k,v|
        if v.kind_of?(Array)
          options[k] = v.join(",")
        end
      end
      res = Net::HTTP.post_form(URI.parse(url), options)
      return res.body
    end
  end # end Annotator class
end # end NCBO module
