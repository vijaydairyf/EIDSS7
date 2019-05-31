﻿using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class SpeciesParameters
    {
        public long SpeciesID { get; set; }
        public long SpeciesMasterID { get; set; }
        public long HerdID { get; set; }
        public long SpeciesTypeID { get; set; }
        public int? SickAnimalQuantity { get; set; }
        public int? TotalAnimalQuantity { get; set; }
        public int? DeadAnimalQuantity { get; set; }
        public DateTime? StartOfSignsDate { get; set; }
        public string AverageAge { get; set; }
        public long? ObservationID { get; set; }
        public string Comments { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}