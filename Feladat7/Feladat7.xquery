xquery version "3.1";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html";
declare option output:indent "yes";
declare option output:html-version "5.0";

declare variable $JSON := fn:json-doc("../EPMA0000001350.json");
declare variable $performers := $JSON?episode?performers?*;

<html>
  <head>
    <meta charset="UTF-8" />
    <title>Actors Information</title>
    <link
      rel="stylesheet"
      href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    />
  </head>
  <body>
    <div class="container mt-5">
      <h2 class="text-center mb-4">Actors Information</h2>
      <table class="table table-bordered table-striped">
        <thead class="thead-dark">
          <tr>
            <th scope="col">Name</th>
            <th scope="col">Birth Name</th>
            <th scope="col">Gender</th>
            <th scope="col">Date of Birth</th>
            <th scope="col">Deceased</th>
          </tr>
        </thead>
        <tbody>
          {
            for $performer in $performers
            return
              <tr>
                <td>{ $performer?name }</td>
                <td>{ $performer?birthName }</td>
                <td>{ if ($performer?gender eq 'F') then 'Female' else 'Male' }</td>
                <td>{ $performer?dateOfBirth }</td>
                <td>{ if (exists($performer?dateOfDeath)) then 'Yes' else 'No' }</td>
              </tr>
          }
        </tbody>
      </table>
    </div>
  </body>
</html>
