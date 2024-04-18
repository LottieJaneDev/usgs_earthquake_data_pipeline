## Course Project

### Objective

The goal of this project is to apply everything we have learned
in this course to build an end-to-end data pipeline.

### Problem statement

Develop a dashboard with two tiles by:

* Selecting a dataset of interest (see [Datasets](#datasets))
* Creating a pipeline for processing this dataset and putting it to a datalake
* Creating a pipeline for moving the data from the lake to a data warehouse
* Transforming the data in the data warehouse: prepare it for the dashboard
* Building a dashboard to visualize the data


## Data Pipeline 

The pipeline could be **stream** or **batch**: this is the first thing you'll need to decide 

* **Stream**: If you want to consume data in real-time and put them to data lake
* **Batch**: If you want to run things periodically (e.g. hourly/daily)

## Technologies 

You don't have to limit yourself to technologies covered in the course. You can use alternatives as well:

* **Cloud**: AWS, GCP, Azure, ...
* **Infrastructure as code (IaC)**: Terraform, Pulumi, Cloud Formation, ...
* **Workflow orchestration**: Airflow, Prefect, Luigi, ...
* **Data Warehouse**: BigQuery, Snowflake, Redshift, ...
* **Batch processing**: Spark, Flink, AWS Batch, ...
* **Stream processing**: Kafka, Pulsar, Kinesis, ...

If you use a tool that wasn't covered in the course, be sure to explain what that tool does.

If you're not certain about some tools, ask in Slack.

## Dashboard

You can use any of the tools shown in the course (Data Studio or Metabase) or any other BI tool of your choice to build a dashboard. If you do use another tool, please specify and make sure that the dashboard is somehow accessible to your peers. 

Your dashboard should contain at least two tiles, we suggest you include:

- 1 graph that shows the distribution of some categorical data 
- 1 graph that shows the distribution of the data across a temporal line

Ensure that your graph is easy to understand by adding references and titles.
 
Example dashboard: ![image](example_dashboard.png)


## Peer reviewing

> [!IMPORTANT]  
> To evaluate the projects, we'll use peer reviewing. This is a great opportunity for you to learn from each other.
> * To get points for your project, you need to evaluate 3 projects of your peers
> * You get 3 extra points for each evaluation

> [!NOTE]
> It's highly recommended to create a new repository for your project (not inside an existing repo) with a meaningful title, such as
> "Quake Analytics Dashboard" or "Bike Data Insights" and include as many details as possible in the README file. ChatGPT can assist you with this. Doing so will not only make it easier to showcase your project for potential job opportunities but also have it featured on the [Projects Gallery App](#projects-gallery).
> If you leave the README file empty or with minimal details, there may be point deductions as per the [Evaluation Criteria](#evaluation-criteria).

## Going the extra mile (Optional)

> [!NOTE]
> The following things are not covered in the course, are entirely optional and they will not be graded.

However, implementing these could significantly enhance the quality of your project:

* Add tests
* Use make
* Add CI/CD pipeline

If you intend to include this project in your portfolio, adding these additional features will definitely help you to stand out from others.

## Resources

### Datasets

Refer to the provided [datasets](datasets.md) for possible selection.

### Helpful Links

* [Unit Tests + CI for Airflow](https://www.astronomer.io/events/recaps/testing-airflow-to-bulletproof-your-code/)
* [CI/CD for Airflow (with Gitlab & GCP state file)](https://engineering.ripple.com/building-ci-cd-with-airflow-gitlab-and-terraform-in-gcp)
* [CI/CD for Airflow (with GitHub and S3 state file)](https://programmaticponderings.com/2021/12/14/devops-for-dataops-building-a-ci-cd-pipeline-for-apache-airflow-dags/)
* [CD for Terraform](https://towardsdatascience.com/git-actions-terraform-for-data-engineers-scientists-gcp-aws-azure-448dc7c60fcc)
* [Spark + Airflow](https://medium.com/doubtnut/github-actions-airflow-for-automating-your-spark-pipeline-c9dff32686b)


### Projects Gallery

Explore a collection of projects completed by members of our community. The projects cover a wide range of topics and utilize different tools and techniques. Feel free to delve into any project and see how others have tackled real-world problems with data, structured their code, and presented their findings. It's a great resource to learn and get ideas for your own projects.

[![Streamlit App](https://static.streamlit.io/badges/streamlit_badge_black_white.svg)](https://datatalksclub-projects.streamlit.app/)

### DE Zoomcamp 2023

* [2023 Projects](../cohorts/2023/project.md)

### DE Zoomcamp 2022

* [2022 Projects](../cohorts/2022/project.md)