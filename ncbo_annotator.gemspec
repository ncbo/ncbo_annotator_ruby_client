Gem::Specification.new do |s|
  s.name        = 'ncbo_annotator'
  s.version     = '1.0.0'
  s.date        = '2011-11-11'
  s.summary     = "The NCBO Annotator Gem is a Ruby client for NCBO's Annotator Web service"
  s.description = "The NCBO Annotator Gem is a Ruby client for NCBO's Annotator Web service. The NCBO Annotator (formerly referred to as the Open Biomedical Annotator (OBA)) is an ontology-based Web service that annotates public datasets with biomedical ontology concepts based on their textual metadata. The biomedical community can use the annotator service to tag their data automatically with ontology concepts. These concepts come from the Unified Medical Language System (UMLS) Metathesaurus and the National Center for Biomedical Ontology (NCBO) BioPortal ontologies. Such annotations facilitate translational discoveries by integrating annotated data."
  s.authors     = ["Paul R Alexander"]
  s.email       = 'support@bioontology.org'
  s.files       = Dir['lib/**/*.rb'] + ["lib/ncbo_annotator.rb"]
  s.homepage    = 'http://rubygems.org/gems/ncbo_annotator'
  s.add_runtime_dependency 'libxml-ruby', '~> 1.1.0'
end