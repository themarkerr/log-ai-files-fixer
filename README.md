# Files Fixer

Some summary files where created with strange timestamps
(thanks [jackson](https://github.com/FasterXML/jackson)):

```json
[{"id":50,"promptKey":"...","promptValue":"...","createdAt":[2023,7,31,19,15,41,874025000],"updatedAt":[2023,7,31,19,15,41,874025000]}
```

This repo has a script to correct this if necessary so timestamps look like this:

```json
[{"id":50,"promptKey":"...","promptValue":"...","createdAt":"2023-11-16T15:39:34.552194","updatedAt":"2023-11-16T15:39:34.552196"}
```

## requirements

- aws cli and proper aws credentials
- node.js
- bash

## usage

```bash
sh file-fixer.sh <bucket name here>
```

## further reading

- <https://github.com/FasterXML/jackson-modules-java8#jackson-30>
- <https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html#using-s3-commands-managing-objects-copy>
