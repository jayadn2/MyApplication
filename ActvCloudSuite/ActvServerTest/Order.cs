using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ActvServerTest
{
    public class Order
    {
        public int OrderID { get; set; }
        public string CustomerName { get; set; }
        public string ShipperCity { get; set; }
        public Boolean IsShipped { get; set; }

        public static List<Order> CreateOrders()
        {
            List<Order> OrderList = new List<Order>
            {
                new Order {OrderID = 10248, CustomerName = "Sri Rama", ShipperCity = "Ayodhya", IsShipped = true },
                new Order {OrderID = 10249, CustomerName = "Sri Krishna", ShipperCity = "Mathura", IsShipped = false},
                new Order {OrderID = 10250,CustomerName = "Shiva", ShipperCity = "Kailasa Parvatha", IsShipped = false },
                new Order {OrderID = 10251,CustomerName = "Anjaneya", ShipperCity = "Hampi", IsShipped = false},
                new Order {OrderID = 10252,CustomerName = "Ravana", ShipperCity = "Sri Lanka", IsShipped = true}
            };

            return OrderList;
        }
    }
}
