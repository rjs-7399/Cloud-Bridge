# 🌉 **CloudBridge**

## 📄 **Project Overview**  
CloudBridge is a modernization initiative aimed at migrating from a legacy on-premises database architecture to a cloud-native solution on Azure. This transformation leverages cloud capabilities to enhance **scalability**, **performance**, and **maintainability** while addressing the limitations of the legacy infrastructure.


## 🎯 **Purpose**  
This modernization initiative addresses key business needs:  

- **🔧 Reduce Development Overhead**: Minimize manual interventions, SSIS package maintenance, and transformation rule implementation.  
- **📈 Improve Scalability**: Overcome the limitations of handling increasing data volumes and concurrent processing requirements.  
- **🛠 Enhance Maintainability**: Simplify updates and reduce complexities from multiple technology stacks.  
- **⏩ Accelerate Development Cycles**: Streamline workflows to speed up feature delivery and reduce time-to-market.  


## 🏗 **Architecture**  

### 🔙 **Legacy System**  

```mermaid
flowchart TB
    subgraph "Source Systems"
        EDS["Enterprise Data Service (EDS)"]
        EDS --> |CSV| WF["Workflow Engine"]
        EDS --> |DAT| WF
        EDS --> |JSON| WF
    end

    subgraph "Data Processing Layer"
        WF --> |Format Headers\nBal_dt\nFooter\nField Mapping| OF["Outbound Files"]

        subgraph "Outbound File Types"
            OF --> CRED["OEDS_FIN_RPT_CC\n(Credit Data)"]
            OF --> DEP["OEDS_FIN_MTX_SAV\n(Deposit Data)"]
            OF --> LOAN["OEDS_FIN_GLB_LNS\n(Loan Data)"]
            OF --> WSD["Other Wall Street Data"]
        end
    end

    subgraph "SSIS Integration Layer"
        SSIS["SSIS Packages"]
        CRED --> |Credit Package| SSIS
        DEP --> |Deposit Package| SSIS
        LOAN --> |Loan Package| SSIS
        WSD --> |Wall Street Package| SSIS
    end

    subgraph "Database Layers (SSMS)"
        subgraph "Bronze (Stage)"
            SSIS --> STG_DEP["t_fin_savings_stg"]
            SSIS --> STG_LOAN["t_fin_loans_stg"]
            SSIS --> STG_CRED["t_fin_credit_stg"]
        end

        subgraph "Silver (Position)"
            STG_DEP --> |Basic\nTransformation| POS_DEP["t_fin_savings_pstn"]
            STG_LOAN --> |Basic\nTransformation| POS_LOAN["t_fin_loans_pstn"]
            STG_CRED --> |Basic\nTransformation| POS_CRED["t_fin_credit_pstn"]
        end

        subgraph "Gold (Normalize)"
            POS_DEP --> |Business\nRules| NRM_DEP["t_fin_savings_nrm"]
            POS_LOAN --> |Business\nRules| NRM_LOAN["t_fin_loans_nrm"]
            POS_CRED --> |Business\nRules| NRM_CRED["t_fin_credit_nrm"]
        end
    end

    subgraph "Presentation Layer"
        DWH["Data Warehouse"]
        NRM_DEP --> DWH
        NRM_LOAN --> DWH
        NRM_CRED --> DWH
        DWH --> DASH["Central Dashboard\n(Charts & Tables)"]
    end

    subgraph "Batch Processing"
        BATCH["Legacy Batch Job"]
        BATCH -.-> |"Orchestrates\nEntire Flow"| OF
        BATCH -.-> |"Controls\nTransformations"| SSIS
        BATCH -.-> |"Manages\nData Loading"| DWH
    end
```

The legacy system was based on:  
- On-premises SQL Server (SSMS)  
- Data workflows implemented using SSIS  
- A complex multi-layered architecture  

### 🌐 **CloudBridge Solution**  

![Descriptive Alt Text](./diagrams/cloud_bridge.jpg)

CloudBridge adopts Azure’s **cloud-native services** to achieve:  
- Automated, scalable data pipelines  
- Enhanced performance using Databricks and Synapse Analytics  
- Streamlined architecture  

> [!IMPORTANT]  
> For detailed implementation please checkout [implementation guide](implementation/implementation.md)

## ⚖ **Legacy vs. CloudBridge**  

### ⚠️ **Challenges with Legacy Architecture**  

| **Aspect**            | **Legacy System**                              | **Impact**                      |
|------------------------|-----------------------------------------------|----------------------------------|
| Development Time       | 3 weeks per feature                           | Slow delivery cycles            |
| Resource Utilization   | 30 developers for maintenance                 | High operational costs          |
| Technology Stack       | EDS → SSIS → SSMS → Web UI                    | Complex maintenance             |
| Data Processing        | Manual transformations, error-prone           | Delays and reliability issues   |
| Scalability            | Limited by on-premises infrastructure         | Performance bottlenecks         |

### 🌟 **Benefits of CloudBridge**  

| **Aspect**            | **Modern System**                              | **Impact**                      |
|------------------------|-----------------------------------------------|----------------------------------|
| Development Time       | Automated processes, minimal manual effort    | Faster feature delivery         |
| Resource Utilization   | Optimized team size                           | Reduced operational costs       |
| Technology Stack       | Azure-native tools (ADF, Databricks, Synapse) | Simplified maintenance          |
| Data Processing        | Automated pipelines using PySpark             | Improved reliability            |
| Scalability            | Elastic cloud scaling                         | Enhanced performance            |



## 🔄 **Data Flow**  

1. **📥 Raw Data Ingestion**: Data from EDS is stored in **SSMS**.  
2. **🔄 Data Movement**: Azure Data Factory orchestrates transfer to **Azure Data Lake**.  
3. **⚙️ Data Transformation**: Databricks notebooks process data using **PySpark**.  
4. **📂 Storage**: Processed data is stored in **Azure Synapse Analytics**.  
5. **📊 Visualization**: Power BI provides analytics and reporting.  



## 🛠 **Technologies Used**  

### ☁️ **Cloud Platform**  
- **Azure Cloud**: Core platform hosting all services.  

### 🗂 **Data Storage & Processing**  
- **Azure Data Factory**: Data integration service.  
- **Azure Data Lake**: Tiered data storage (Bronze, Silver, Gold).  
- **Azure Synapse Analytics**: Scalable analytics service.  
- **Azure Databricks**: Big data processing platform.  

### 🔄 **Data Integration & Transformation**  
- **PySpark**: Engine for scalable data processing.  
- **Databricks Notebooks**: Development environment for transformation logic.  

### 📊 **Visualization & Reporting**  
- **Power BI**: BI and visualization platform.  

![BI Dashboard](diagrams/implementation/power_bi_report.jpg)

### 📡 **Source System**  
- **Enterprise Data Service (EDS)**: Primary raw data source.
