#[ derive( Drop ) ]
enum CoffeType{
    Americano,
    Espresso,
    Latte,
    Cappucino
}

#[ derive( Drop ) ]
struct Order {
    coffeType: CoffeType,
    coffeSize: CoffeSize,
}

#[ derive( Drop ) ]
enum CoffeSize{
    Small,
    Medium,
    Large
}

#[ derive( Drop ) ]
struct Stock {
    milk: u32,
    coffeeBeans: u32
}

trait PriceTrait {
    fn calculatePrice( self: @CoffeType, size: @CoffeSize ) -> u32;
}

trait stockCheckTrait {
    fn inStock( self:  @CoffeType , stock: @Stock ) -> bool;
    fn neededIngridient( self: @CoffeType );
}

impl CoffePriceImpl of PriceTrait {
    fn calculatePrice( self: @CoffeType, size: @CoffeSize ) -> u32 {

        let basePrice: u32 = match self{

            CoffeType::Americano => 30,
            CoffeType::Espresso => 25,
            CoffeType::Latte => 40,
            CoffeType::Cappucino => 20
        };

        let sizePrice = match size {

            CoffeSize::Small => 5,
            CoffeSize::Medium => 7,
            CoffeSize::Large => 9
        };

        basePrice + sizePrice
    }
}

impl StockCheckImpl of stockCheckTrait {
    fn inStock( self: @CoffeType, stock: @Stock ) -> bool {
        let beans = *stock.coffeeBeans;
        let milk = *stock.milk;

        match self {
            // Needs atleast 25g of coffe beans
            CoffeType::Americano => beans >= 25,
            // Needs atleast 20g of beans and 80ml of milk
            CoffeType::Cappucino => beans >= 20 && milk >= 80,
            // Needs atleast 20g of beans and 100ml of milk
            CoffeType::Latte => beans >= 20 && milk >= 100,
            // Needs atleast 20g of beans and 50ml of milk
            CoffeType::Espresso => beans >=20,
        }
    }

    fn neededIngridient( self: @CoffeType ) {
        match self {
            CoffeType::Americano => println!( "For Americano we need: 25g of coffee beans" ),
            CoffeType::Cappucino => println!( "For Cappucino we need: 20g of coffee beans and 80ml of milk" ),
            CoffeType::Latte => println!( "For Latte we need: 20g of coffee beans and 100ml of milk" ),
            CoffeType::Espresso => println!( "For Espresso we need 20g of coffee beans" )
        }
    }

}

fn processOrder( order: Order, stock: @Stock ){
    let coffee = @order.coffeType;

    if stockCheckTrait::inStock( coffee, stock ){

        let price = PriceTrait::calculatePrice( coffee, @order.coffeSize );
        println!("Your coffee is avalable and ready, here is your charge: {price}");
    } else {

        println!("Sorry, we are out of stock for this coffee type");
        stockCheckTrait::neededIngridient( coffee );
    }
}

fn main() {
    let shopStock = Stock{ milk: 200, coffeeBeans: 400 };

    let customer1Order = Order{ coffeType: CoffeType::Americano, coffeSize: CoffeSize::Medium };

    print!("Processing order for customer 1: ");
    processOrder( customer1Order, @shopStock );
}