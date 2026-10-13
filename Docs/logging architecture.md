    logging architecture



                    MASTER_ETL
                        │
                        │
                usp_Start_ETL_Run
                        │
                        ▼
                    RunID = 25
                        │
                        │
              Execute Package Task
                        │
                        ▼
                 Load_Staging.dtsx
                        │
          ┌─────────────┼──────────────┐
          ▼             ▼              ▼
       Customers      Stores        Products
          │             │              │
          └─────────────┼──────────────┘
                        ▼
                  Staging Loaded
                        │
                        ▼
                  Load Main Tables
                        │
          ┌─────────────┼──────────────┐
          ▼             ▼              ▼
      Customers       Stores        Products
          │
          ▼
       Orders
          │
          ▼
    Order Items
          │
          ▼
   Support Tickets
          │
          ▼
      Telemetry
                        │
                        ▼
                usp_End_ETL_Run
                        │
                  SUCCESS/FAILED