require 'rubygems'
require 'net/http'
require 'xml'
require 'uri'
require 'ncbo_annotator/parser'

module NCBO
  class Annotator

    def initialize(args = {})
      @options = {}
  
      @options[:annotator_location] = "http://rest.bioontology.org/obs/annotator"
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
      
      result_xml = post
      Parser::Annotator.parse_results(result_xml)
    end
    
    def options
      @options
    end

    private

    def post
      url = @options[:annotator_location]
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