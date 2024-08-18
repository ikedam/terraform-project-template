# Terraform のプロジェクトテンプレート

## 設定

* AWS のインフラを構築するテンプレート
    * 別のクラウドサービスを使用する際は、使用するバックエンドやモジュールを変更してください。
* ルートモジュールの切り替えによって dev, stg, prd の環境の切り替えを行う。
* tflint による lint を行う。

## バックエンド用のS3バケットとDynamoDBテーブルの作成

* 各環境の AWS に S3 バケットと DynamoDB テーブルを作成してください。
* 動作を試すだけならば、 DynamoDB テーブルの作成はオプションです。
* S3 バケットや DynamoDB テーブルの設定方法や設定のベストプラクティスは Terraform のドキュメントを参照してください: https://developer.hashicorp.com/terraform/language/settings/backends/s3

## バックエンドの設定

各環境の `env/ENV/main.tf` 内で `FIXME` となっている以下の項目について、使用する AWS アカウント、作成したバックエンド用の S3 バケット、DynamoDB テーブルを設定してください:

* terraform.backend.s3.bucket
* terraform.backend.s3.dynamodb_table
* provider.aws.allowed_account_ids

## ロックファイルの作成・更新

以下のコマンドで全環境の `.terraform.lock.hcl` を更新します:

``` console
make lock
```

## terraform init の実行

以下のコマンドで指定した環境について `terraform init` を実行します。
**AWS の認証が必要です。**

```console
make init ENV=dev
```

## lint の実行

以下のコマンドで指定した環境について lint を実行します。
AWS の認証は必要ありませんが、事前に `make init` の実行が必要です。

```console
make lint ENV=dev
```

## インフラの構築

以下のコマンドで指定した環境について `terraform plan` および `terraform apply` を実行します。
**AWS の認証が必要です。**

```console
make plan ENV=dev
make apply ENV=dev
```

## 出力の取得

以下のコマンドで構築したインフラの output を取得できます。
**AWS の認証が必要です。**

```console
make output-dynamodb_table_arn
```

## インフラの削除

※Makefile 内でコメントアウトされているので必要な場合はアンコメントしてください。

以下のコマンドで指定した環境について `terraform destroy` を実行します。
**AWS の認証が必要です。**

```console
make destroy ENV=dev
```
