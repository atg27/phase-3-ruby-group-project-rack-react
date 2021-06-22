class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env) 
    if req.path.match(/test/) 
      return [200, { 'Content-Type' => 'application/json' }, [ {:message => "test response!"}.to_json ]]
    elsif req.path.match(/publications/) 
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        author_id = req.path.split('/authors/').last.split('/publications').last
        author = Author.find_by(id: author_id)
        publication = author.publications.create(title: input["title"])
        return [200, { 'Content-Type' => 'application/json' }, [ publication.to_json ]]
      elsif req.env["REQUEST_METHOD"] == "DELETE"
        author_id = req.path.split('/authors/').last.split('/publications/').first
        author = Author.find_by(id: author_id)
        publication_id = req.path.split('/publications/').last
        publication = author.publications.find_by(id: publication_id)
        publication.destroy()
      elsif req.env["REQUEST_METHOD"] == "PATCH"
        input = JSON.parse(req.body.read)
        author_id = req.path.split('/authors/').last.split('/publications/').first
        author = Author.find_by(id: author_id)
        publication_id = req.path.split('/publications/').last
        publication = author.publications.find_by(id: publication_id)
        publication.update(input)
        return [200, { 'Content-Type' => 'application/json' }, [ publication.to_json ]]
      end
    elsif req.path.match(/authors/) 
        if req.env["REQUEST_METHOD"] == "POST"
          input = JSON.parse(req.body.read)
          author = Author.create(name: input["name"])
          return [200, { 'Content-Type' => 'application/json' }, [ author.to_json ]]

        else
          if req.path.split("/authors").length == 0
            return [200, { 'Content-Type' => 'application/json' }, [ Author.all.to_json ]]
          else 
            author_id = req.path.split("/authors/").last
            return [200, { 'Content-Type' => 'application/json' }, [ Author.find_by(id: author_id).to_json({:include => :publications}) ]]
          end
        end
    else
      resp.write "Path Not Found"

    end

    resp.finish
  end

end
