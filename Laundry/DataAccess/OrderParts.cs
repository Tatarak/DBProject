//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DataAccess
{
    using System;
    using System.Collections.Generic;
    
    public partial class OrderParts
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public Nullable<int> PriceId { get; set; }
        public Nullable<int> Number { get; set; }
    
        public virtual Orders Orders { get; set; }
        public virtual Prices Prices { get; set; }
    }
}
