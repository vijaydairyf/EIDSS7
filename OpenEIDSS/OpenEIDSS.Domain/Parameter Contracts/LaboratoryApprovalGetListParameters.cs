﻿using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters used with a call to the LaboratoryController.LaboratoryApprovalGetListAsync service method
    /// </summary>
    public sealed class LaboratoryApprovalGetListParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long? SiteID { get; set; }
        public bool SpecificApprovalTypeIndicator { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}