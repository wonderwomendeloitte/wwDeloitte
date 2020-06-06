public class WW_CovidWrapper {
		@AuraEnabled public data data{get;set;}
		@AuraEnabled public String status{get;set;}


    public class rows{
		@AuraEnabled public String total_deaths{get;set;}
		@AuraEnabled public String new_cases{get;set;}
		@AuraEnabled public String new_deaths{get;set;}
		@AuraEnabled public String total_cases{get;set;}
		@AuraEnabled public String total_recovered{get;set;}
		@AuraEnabled public String country_abbreviation{get;set;}
		@AuraEnabled public String active_cases{get;set;}
		@AuraEnabled public String country{get;set;}
		@AuraEnabled public String serious_critical{get;set;}
		@AuraEnabled public String cases_per_mill_pop{get;set;}
		@AuraEnabled public String flag{get;set;}
	}
	public class paginationMeta{
		public Integer totalRecords{get;set;}
		public Integer totalPages{get;set;}
		public Integer currentPageSize{get;set;}
		public Integer currentPage{get;set;}
	}
	public class data{
		@AuraEnabled public String last_update{get;set;}
		@AuraEnabled public list<rows> rows{get;set;}
		@AuraEnabled public paginationMeta paginationMeta{get;set;}
	}

}