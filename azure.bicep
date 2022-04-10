param location string = 'westeurope'
param env string = 'dev'

var botPlanName = 'plan-feedbackbot-${env}'
var botIdentityName = 'id-feedbackbot-${env}'
var botName = 'bot-feedbackbot-${env}'
var botSiteName = 'app-feedbackbot-${env}'

resource botIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: botIdentityName
  location: location
}

resource botPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: botPlanName
  location: location
  sku: {
    name: 'F0'
  }
  kind: 'linux'
}

resource botWebApp 'Microsoft.Web/sites@2021-03-01' = {
  name: botSiteName
  location: location
  properties: {
    serverFarmId: botPlan.id
  }
}

resource feedbackBot 'Microsoft.BotService/botServices@2021-05-01-preview' = {
  name: botName
  location: location
  sku: {
    name: 'F0'
  }
  kind: 'azurebot'
  properties: {
    description: 'Bot for collecting feedback'
    displayName: 'Feedback bot'
    endpoint: 'https://${botWebApp.name}.azurewebsites.net/api/messages'
    msaAppId: botIdentity.properties.clientId
  }
}
