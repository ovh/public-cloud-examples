import { ChatMistralAI } from "@langchain/mistralai";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import { Command } from 'commander';
import { setTimeout } from "timers/promises";

/**
 * Function to do a chat completion request to the LLM given a user question.
 * @param question (String) the question to ask to the LLM.
 */
async function chatCompletion(question) {
  const promptTemplate = ChatPromptTemplate.fromMessages([
    ["system", "You are Nestor, a virtual assistant. Answer to the question."],
    ["human", "{question}"]
  ]);

  // Use Mixtral-8x22B as LLM
  const model = new ChatMistralAI({
    modelName: "Mixtral-8x22B-Instruct-v0.1",
    model: "Mixtral-8x22B-Instruct-v0.1",
    apiKey: "None",
    endpoint: "https://mixtral-8x22b-instruct-v01.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/",
    maxTokens: 1500,
    streaming: true,
    verbose: false,
  });

  // Chain the model to the prompt to "apply it"
  const chain = promptTemplate.pipe(model);
  const stream = await chain.stream({ question: question });

  for await (const chunk of stream) {
    // Timeout to simulate a human answering the question
    await setTimeout(150);
    process.stdout.write(chunk.content);
  }
}

/**
 * Main entry of the CLI.
 * Parameter --question is used to pass the question to the LLM.
 **/
const program = new Command();

program
  .option('--question <value>', 'Overwriting value.', '"What is the meaning of life?"')
  .parse(process.argv);

const options = program.opts();
chatCompletion(options.question);