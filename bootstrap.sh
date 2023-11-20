#!/bin/bash
set -Eeuo pipefail

create_spanner_instance() {
  echo "ℹ️  Creating spanner instance $1"
  gcloud spanner instances create $1 --config=emulator-config --description=Emulator --nodes=1
  echo "✅ Created spanner instance $1"
}

create_spanner_database() {
  echo "ℹ️  Creating database $1.$2"
  gcloud spanner databases create "$2" --instance=$1
  echo "✅ Created database $1.$2"
}

echo "using databases from $INIT_DIR"

IS_EMULATOR_ACTIVE=$(gcloud config configurations list --filter name=emulator --format="value(is_active)")
if [[ "$IS_EMULATOR_ACTIVE" == "True" ]]; then
  echo "Emulator config already active"
elif [[ "$IS_EMULATOR_ACTIVE" == "False" ]]; then
  echo "Activating emulator config"
  gcloud config congigurations activate emulator
else
  echo "Creating emulator config"
  gcloud config configurations create emulator
  gcloud config set auth/disable_credentials true
  gcloud config set project ${PROJECT_ID}
  gcloud config set api_endpoint_overrides/spanner ${SPANNER_EMULATOR_URL}
fi

create_spanner_instance $INSTANCE_NAME

cd $INIT_DIR
for DATABASE_NAME in *; do
  if [ -d "$DATABASE_NAME" ]; then
    create_spanner_database $INSTANCE_NAME $DATABASE_NAME
    for DDL in $DATABASE_NAME/ddl/*; do
      gcloud spanner databases ddl update $DATABASE_NAME --instance=${INSTANCE_NAME} --ddl-file=/usr/bin/$INIT_DIR/$DDL
    done

    for DML in $DATABASE_NAME/dml/*; do
      gcloud spanner databases execute-sql $DATABASE_NAME --instance=${INSTANCE_NAME} --sql="$(< /usr/bin/$INIT_DIR/$DML)"
    done
  fi
  echo "✅ set up spanner database $DATABASE_NAME"
done

echo "✅ set up spanner instance $INSTANCE_NAME"