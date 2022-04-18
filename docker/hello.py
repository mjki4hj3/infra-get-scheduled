import falcon

class HelloResource(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        resp.body = ("Hello, World!")

class Page2Resource(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        resp.body = ("This is the second page!")

app = falcon.API()

hello = HelloResource()

page2 = Page2Resource()

app.add_route('/', hello)
app.add_route('/page2', page2)