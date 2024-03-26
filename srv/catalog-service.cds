using {com.alfa as alfa} from '../db/schema';
//using {com.training as training} from '../db/training';

// service Catalog {

//     entity ProductsSrv      as projection on alfa.materials.Products;
//     entity SuppliersSrv     as projection on alfa.sales.Suppliers;
//     entity CurrencySrv      as projection on alfa.materials.Currencies;
//     entity DimensionUnitSrv as projection on alfa.materials.DimensionUnits;
//     entity CategorySrv      as projection on alfa.materials.Categories;
//     entity SalesDataSrv     as projection on alfa.sales.SalesData;
//     entity ReviewsSrv       as projection on alfa.materials.ProductReview;
//     entity UnitOfMeasureSrv as projection on alfa.materials.UnitOfMeasures;
//     entity MonthsSrv        as projection on alfa.sales.Months;
//     entity OrderSrv         as projection on alfa.sales.Orders;
//     entity OrderItemsSrv    as projection on alfa.sales.OrderItems;

//     entity StudentSrv AS projection ON training.Student;

// }

//@graphql
define service CatalogService {

    entity Products          as
        select from alfa.reports.Products {
            ID,
            Name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                            @(
                mandatory,
                assert.range: [
                    0.00,
                    20
                ]
            ),
            Height,
            Width,
            Quantity                         @mandatory,
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Currency.ID   as CurrencyId,      
            Category      as ToCategory      @mandatory,
            Category.ID   as CategoryId,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit @mandatory,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailibility
        };

    @readonly
    entity Supplier          as
        select from alfa.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from alfa.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from alfa.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth             as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from alfa.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from alfa.materials.Categories {
            ID   as Code,
            Name as Text
        };

    @readonly
    entity VH_Currencies     as
        select from alfa.materials.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from alfa.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from alfa.materials.DimensionUnits;

};

define service MyService {

    entity SuppliersProduct  as
        select from alfa.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 98074;

    entity SuppliersToSales  as
        select
            Supplier.Email,
            Category.Name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from alfa.materials.Products;

    entity EntityInFix       as
        select Supplier[Name = 'Exotic Liquids'].Phone from alfa.materials.Products
        where
            Products.Name = 'Bread';

    entity EntityJoin        as
        select Phone from alfa.materials.Products
        left outer join alfa.sales.Suppliers as supp
            on(
                supp.ID = Products.Supplier.ID
            )
            and supp.Name = 'Exotic Liquids'
        where
            Products.Name = 'Bread';
};

define service Reports {

    entity AverageRating     as projection on alfa.reports.AverageRating;

    entity EntityCasting     as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as price2 : Integer
        from alfa.materials.Products;

    entity EntityExists      as
        select from alfa.materials.Products {
            Name
        }
        where
            exists Supplier[Name = 'Exotic Liquids'];
};