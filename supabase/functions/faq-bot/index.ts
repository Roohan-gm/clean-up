import { serve } from "https://deno.land/x/sift/mod.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";


// Initialize Supabase client using environment variables
const supabase = createClient(
  Deno.env.get("SUPABASE_URL") || "",
  Deno.env.get("SUPABASE_ANON_KEY") || ""
);

serve(async (req) => {
  try {
    // Ensure it's a POST request
    if (req.method !== "POST") {
      return new Response("Method Not Allowed", { status: 405 });
    }

    const { query } = await req.json(); // User's query
    if (!query || typeof query !== "string") {
      return new Response(
        JSON.stringify({ error: "Invalid or missing 'query' field." }),
        { headers: { "Content-Type": "application/json" }, status: 400 }
      );
    }

    // Search FAQs table for matching questions
    const { data, error } = await supabase
      .from("FAQs")
      .select("*")
      .ilike("question", `%${query}%`);

    if (error) {
      console.error("Supabase error:", error);
      return new Response(
        JSON.stringify({ error: "Failed to fetch FAQs." }),
        { headers: { "Content-Type": "application/json" }, status: 500 }
      );
    }

    if (!data || data.length === 0) {
      return new Response(
        JSON.stringify({ answer: "Sorry, I couldn't find an answer to that." }),
        { headers: { "Content-Type": "application/json" } }
      );
    }

    // Return the first matched answer
    return new Response(
      JSON.stringify({ answer: data[0].answer }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("Error handling request:", err);
    return new Response(
      JSON.stringify({ error: "Internal Server Error." }),
      { headers: { "Content-Type": "application/json" }, status: 500 }
    );
  }
});
