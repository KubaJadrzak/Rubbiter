// cypress/integration/orders_spec.js

describe('Order Payment Flow', () => {
    beforeEach(() => {
        // Use the devLogin command to log in the user during development
        cy.devLogin();
        cy.visit('/orders/new');
    });

    it('successfully creates an order with valid input and valid payment', () => {
        // Fill out the form with valid data on your main app
        cy.get('input[name="order[country]"]').type('USA');
        cy.get('input[name="order[street]"]').type('123 Main St');
        cy.get('input[name="order[postal_code]"]').type('90210');

        // Submit the form
        cy.get('form').submit();

        // Now, we use cy.origin() to interact with the new domain after the redirect
        cy.origin('https://sandbox.espago.com', () => {
            // Assert that the URL has changed to the sandbox payment page
            cy.url().should('include', '/secure_web_page'); // Check the relevant part of the URL


            // Optionally, assert payment confirmation or any response on the sandbox page
            cy.get('body').should('contain', 'Submit credit card data'); // Replace with actual confirmation text
        });
    });

});