## About

The NCBO Annotator Gem is a Ruby client for NCBO's Annotator Web service. The NCBO Annotator (formerly referred to as the Open Biomedical Annotator (OBA)) is an ontology-based Web service that annotates public datasets with biomedical ontology concepts based on their textual metadata. The biomedical community can use the annotator service to tag their data automatically with ontology concepts. These concepts come from the Unified Medical Language System (UMLS) Metathesaurus and the National Center for Biomedical Ontology (NCBO) BioPortal ontologies. Such annotations facilitate translational discoveries by integrating annotated data.

## Installation

    gem install libxml-ruby
    gem install ncbo_annotator

## Usage

You must always supply an NCBO API Key when using the annotator. To get an NCBO API Key, please create an account at [NCBO BioPortal](http://bioportal.bioontology.org/accounts/new).

### Without instantiation
    result = NCBO::Annotator.annotate("melanoma", :apikey => "your API Key")

### With instantiation
    annotator = NCBO::Annotator.new(:apikey => "your API Key")
    result_melanoma = annotator.annotate("melanoma")
    result_cancer = annotator.annotate("cancer")
    
## Available Options
The following default options are used with the NCBO Annotator Web service via the client.

    annotator_location       = "http://rest.bioontology.org/obs/annotator"
    filterNumber             = true
    isStopWordsCaseSensitive = false
    isVirtualOntologyId      = true
    levelMax                 = 0
    longestOnly              = false
    ontologiesToExpand       = []
    ontologiesToKeepInResult = []
    mappingTypes             = []
    minTermSize              = 3
    scored                   = true
    semanticTypes            = []
    stopWords                = []
    wholeWordOnly            = true
    withDefaultStopWords     = false
    withSynonyms             = true
    
Default options may be overridden by providing them as follows:

    annotator = NCBO::Annotator.new(:apikey => "your API Key", :minTermSize => 5, :ontologiesToKeepInResult => [1032, 1084])
    annotator = NCBO::Annotator.new(:apikey => "your API Key", :wholeWordOnly => false, :levelMax => 2)
    annotator = NCBO::Annotator.new(:apikey => "your API Key", :semanticTypes => ["T047", "T048", "T191"])
    
For more information on available option values, please see the NCBO Annotator [Web service documentation](http://www.bioontology.org/wiki/index.php/Annotator_User_Guide#Annotator_Web_Service_Parameters).

## Contact
For questions please email [support@bioontology.org](support@bioontology.org).

## License (BSD two-clause)

Copyright (c) 2011, The Board of Trustees of Leland Stanford Junior University
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE BOARD OF TRUSTEES OF LELAND STANFORD JUNIOR UNIVERSITY
''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL The Board of Trustees of Leland Stanford Junior University OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of The Board of Trustees of Leland Stanford Junior University.




