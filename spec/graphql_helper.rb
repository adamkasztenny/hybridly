def execute_query(query_string)
  result = HybridlySchema.execute(query_string)
  expect(result["errors"]).to be nil

  return result["data"]
end
