require 'rubygems'
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

# text = "Background
# Nck1 and Nck2 adaptor proteins are involved in signaling pathways mediating proliferation, cytoskeleton organization and integrated stress response. Overexpression of Nck1 in fibroblasts has been shown to be oncogenic. Through the years this concept has been challenged and the consensus is now that overexpression of either Nck cooperates with strong oncogenes to transform cells. Therefore, variations in Nck expression levels in transformed cells could endorse cancer progression.
# Methods
# Expression of Nck1 and Nck2 proteins in various cancer cell lines at different stages of progression were analyzed by western blots. We created human primary melanoma cell lines overexpressing GFP-Nck2 and investigated their ability to proliferate along with metastatic characteristics such as migration and invasion. By western blot analysis, we compared levels of proteins phosphorylated on tyrosine as well as cadherins and integrins in human melanoma cells overexpressing or not Nck2. Finally, in mice we assessed tumor growth rate of human melanoma cells expressing increasing levels of Nck2.
# Results
# We found that expression of Nck2 is consistently increased in various metastatic cancer cell lines compared with primary counterparts. Particularly, we observed significant higher levels of Nck2 protein and mRNA, as opposed to no change in Nck1, in human metastatic melanoma cell lines compared with non-metastatic melanoma and normal melanocytes. We demonstrated the involvement of Nck2 in proliferation, migration and invasion in human melanoma cells. Moreover, we discovered that Nck2 overexpression in human primary melanoma cells correlates with higher levels of proteins phosphorylated on tyrosine residues, assembly of Nck2-dependent pY-proteins-containing molecular complexes and downregulation of cadherins and integrins. Importantly, we uncovered that injection of Nck2-overexpressing human primary melanoma cells into mice increases melanoma-derived tumor growth rate.
# Conclusions
# Collectively, our data indicate that Nck2 effectively influences human melanoma phenotype progression. At the molecular level, we propose that Nck2 in human primary melanoma promotes the formation of molecular complexes regulating proliferation and actin cytoskeleton dynamics by modulating kinases or phosphatases activities that results in increased levels of proteins phosphorylated on tyrosine residues. This study provides new insights regarding cancer progression that could impact on the therapeutic strategies targeting cancer."
# ontology_ids = "1090,1568,1530,1114,1104,1089,1116,1487,1314,1541,1006,1007,1063,1144,1008,1015,1053,1019,1070,1506,1440,1021,1517,1022,1362,1516,1553,1350,1027,1422,1152,1030,1000,1010,1032,1321,1084,1076,1328,1656,1107,1062,1057,1353,1078,1091,1068,1110,1065,1574,1095,1051"
# 
# NCBO::Annotator.annotate(text, :apikey => "api key", :ontologiesToKeepInResult => ontology_ids, :withDefaultStopWords => true)