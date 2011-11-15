module NCBO
  module Parser

    class BaseParser
      def parse_xml(xml)
        if xml.kind_of?(String)
          parser = XML::Parser.string(xml, :options => LibXML::XML::Parser::Options::NOBLANKS)
        else
          parser = XML::Parser.io(xml, :options => LibXML::XML::Parser::Options::NOBLANKS)
        end
        parser.parse
      end
      
      def safe_to_i(str)
        Integer(str) rescue str
      end
    end
    
    class Annotator < BaseParser
      def initialize(results)
        @root = "/success/data/annotatorResultBean"
        @results = parse_xml(results)
        @result = AnnotatorResult.new
      end
      
      def self.parse_results(results)
        new(results).parse_results
      end
      
      def parse_results
        @result.id = @results.find_first(@root + "/resultID").content
        @result.statistics = parse_statistics
        @result.annotations = parse_annotations
        @result.ontologies = parse_ontologies
        @result
      end
      
      def parse_statistics
        statistics = {}
        @results.find(@root + "/statistics/statisticsBean").each do |statistic|
          statistics[statistic.children[0].content.downcase.to_sym] = statistic.children[1].content.to_i
        end
        statistics
      end
      
      def parse_annotations
        annotations = []
        @results.find(@root + "/annotations/annotationBean").each do |annotation|
          a = {}
          a[:score] = annotation.find_first("score").content.to_i
          a[:concept] = parse_concept(annotation)
          a[:context] = parse_context(annotation)
          annotations << a
        end
        annotations
      end
      
      def parse_ontologies
        ontologies = []
        @results.find(@root + "/ontologies/ontologyUsedBean").each do |ontology|
          ont = {}
          ontology.children.each {|child| ont[child.name.to_sym] = safe_to_i(child.content)}
          ontologies << ont
        end
        ontologies
      end
      
      private
      
      def parse_concept(annotation, concept_location = "concept")
        a = {}
        annotation.find("#{concept_location}/*").each {|child| a[child.name.to_sym] = safe_to_i(child.content) if !child.first.nil? && !child.first.children?}
        
        a[:synonyms] = annotation.find("#{concept_location}/synonyms/string").map {|syn| safe_to_i(syn.content)}

        semantic_types = {}
        annotation.find("#{concept_location}/semanticTypes/semanticTypeBean/*").each {|child| semantic_types[child.name.to_sym] = safe_to_i(child.content)}
        a[:semantic_types] = semantic_types
        
        a
      end
      
      def parse_context(annotation)
        a = {}
        annotation.find("context/*").each {|child| a[child.name.to_sym] = safe_to_i(child.content) if !child.first.nil? && !child.first.children?}
        
        if a[:contextName].downcase.include?("mapping")
          a[:mappedConcept] = parse_concept(annotation.find_first("context"), "mappedConcept")
        elsif a[:contextName].downcase.include?("mgrep")
          term = {}
          annotation.find("context/term/*").each {|trm| term[trm.name.to_sym] = safe_to_i(trm.content)}
          a[:term] = term
        elsif a[:contextName].downcase.include?("closure")
          a[:concept] = parse_concept(annotation.find_first("context"))
        end

        a
      end
    end
    
    class AnnotatorResult
      attr_accessor :id, :statistics, :annotations, :ontologies
    end
  end # end Parser module
end # end of NCBO module