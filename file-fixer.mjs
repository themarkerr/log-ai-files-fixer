// file-fixer.js
// attempts to load json file and fix the timestamps
import fs from "fs"
import path from "path"

const filePath = process.argv[2]

const info = path.parse(filePath)

// console.log(`file: ${info.name}${info.ext}`)

const content = fs.readFileSync(filePath)

const data = JSON.parse(content)

data.forEach(element => {
  // console.log(element)
  if (Array.isArray(element.createdAt)) {
    element.createdAt = new Date(...element.createdAt)
  }

  if (Array.isArray(element.updatedAt)) {
    element.updatedAt = new Date(...element.updatedAt)
  }
});

// console.log(data)

const result = JSON.stringify(data)

fs.writeFileSync(`processed/${info.name}${info.ext}`, result)
