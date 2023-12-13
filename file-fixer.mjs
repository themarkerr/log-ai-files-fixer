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
  // convert to new data format: 
  if (element.promptValue) {
    const parts = element.promptValue.split("]")
    const userId = parts
      .find(p => p.includes("[userId"))
      ?.replace(/(.*\[userId: )(.*)/, "$2")
    const prompt = parts
      .find(p => p.includes("[prompt:"))
      ?.replace(/(.*\[prompt: )(.*)/, "$2")
    const response = parts
      .find(p => p.includes("[response:"))
      ?.replace(/(.*\[response: )(.*)/, "$2")
    const stream = parts
      .find(p => p.includes("[stream:"))
      ?.replace(/(.*\[stream: )(.*)/, "$2")
    const type = parts
      .find(p => p.includes("[type:"))
      ?.replace(/(.*\[type: )(.*)/, "$2")
    const geographyType = parts
      .find(p => p.includes("[geographyType:"))
      ?.replace(/(.*\[geographyType: )(.*)/, "$2")
    const geoId = parts
      .find(p => p.includes("[geoId:"))
      ?.replace(/(.*\[geoId: )(.*)/, "$2")

    // apply modern attributes
    element.userId = userId?.trim()
    element.prompt = prompt?.trim()
    element.response = response?.trim()
    element.isStream = stream?.trim()
    element.type = type?.trim()
    element.geographyType = geographyType?.trim()
    element.geoId = geoId?.trim()
    delete element.promptValue
    // console.log(element)
  }
});

// console.log(data)

const result = JSON.stringify(data)

fs.writeFileSync(`processed/${info.name}${info.ext}`, result)
